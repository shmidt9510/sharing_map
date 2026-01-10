import 'dart:async';
import 'dart:io';

import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_http/alice_http_adapter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharing_map/services/core/interceptors/auth.dart';
import 'package:sharing_map/services/core/interceptors/logger.dart';
import 'package:sharing_map/services/core/interceptors/refresh_token.dart';

/// Retry configuration
class RetryConfig {
  final int maxRetries;
  final Duration initialDelay;
  final Duration timeout;
  final double backoffMultiplier;

  const RetryConfig({
    this.maxRetries = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.timeout = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
  });
}

/// Singleton HTTP client with Alice logging, interceptors, and retry logic
class AppHttpClient {
  static final AppHttpClient _instance = AppHttpClient._internal();
  factory AppHttpClient() => _instance;
  AppHttpClient._internal();

  Alice? _alice;
  http.Client? _client;
  AliceHttpAdapter? _adapter;
  bool _isInitialized = false;

  final RetryConfig retryConfig = const RetryConfig();

  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    if (_isInitialized) {
      debugPrint('AppHttpClient already initialized');
      return;
    }

    _alice = Alice(
      configuration: AliceConfiguration(
        navigatorKey: navigatorKey,
        showShareButton: true,
        storage: AliceMemoryStorage(maxCallsCount: 1000),
      ),
    );

    _adapter = AliceHttpAdapter();
    _alice!.addAdapter(_adapter!);

    _client = _InterceptedClient(
      baseClient: http.Client(),
      adapter: _adapter!,
      retryConfig: retryConfig,
      interceptors: [
        LoggerInterceptor(),
        RefreshTokenInterceptor(),
        AuthInterceptor(),
      ],
    );

    _isInitialized = true;
    debugPrint('Alice HTTP Inspector initialized with retry policy');
  }

  Alice get alice {
    _checkInitialized();
    return _alice!;
  }

  http.Client get client {
    _checkInitialized();
    return _client!;
  }

  void showInspector() => _alice?.showInspector();

  void dispose() {
    _client?.close();
    _client = null;
    _alice = null;
    _isInitialized = false;
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'AppHttpClient not initialized. Call initialize(navigatorKey) first.',
      );
    }
  }
}

/// HTTP Client with interceptors, retry logic, and Alice logging
class _InterceptedClient extends http.BaseClient {
  final http.Client baseClient;
  final AliceHttpAdapter adapter;
  final RetryConfig retryConfig;
  final List<HttpInterceptor> interceptors;

  _InterceptedClient({
    required this.baseClient,
    required this.adapter,
    required this.retryConfig,
    required this.interceptors,
  });

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return _sendWithRetry(request);
  }

  Future<http.StreamedResponse> _sendWithRetry(
    http.BaseRequest request, {
    int attempt = 0,
  }) async {
    http.BaseRequest currentRequest = _copyRequest(request);

    // Apply request interceptors
    for (final interceptor in interceptors) {
      currentRequest = await interceptor.interceptRequest(currentRequest);
    }

    try {
      final streamedResponse =
          await baseClient.send(currentRequest).timeout(retryConfig.timeout);

      // Convert to Response for interceptors and Alice
      final response = await http.Response.fromStream(streamedResponse);

      // Log to Alice
      adapter.onResponse(
        response,
        body: currentRequest is http.Request ? currentRequest.body : null,
      );

      // Apply response interceptors
      http.Response interceptedResponse = response;
      for (final interceptor in interceptors) {
        interceptedResponse =
            await interceptor.interceptResponse(interceptedResponse);
      }

      // Check if we should retry
      if (_shouldRetry(interceptedResponse, attempt)) {
        return _retryRequest(request, attempt);
      }

      // Return streamed response
      return http.StreamedResponse(
        Stream.value(interceptedResponse.bodyBytes),
        interceptedResponse.statusCode,
        request: request,
        headers: interceptedResponse.headers,
        reasonPhrase: interceptedResponse.reasonPhrase,
        contentLength: interceptedResponse.bodyBytes.length,
      );
    } on TimeoutException catch (e) {
      debugPrint('Request timeout (attempt ${attempt + 1}): $e');
      if (attempt < retryConfig.maxRetries) {
        return _retryRequest(request, attempt);
      }
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Network error (attempt ${attempt + 1}): $e');
      if (attempt < retryConfig.maxRetries) {
        return _retryRequest(request, attempt);
      }
      rethrow;
    } on http.ClientException catch (e) {
      debugPrint('HTTP client error (attempt ${attempt + 1}): $e');
      if (attempt < retryConfig.maxRetries) {
        return _retryRequest(request, attempt);
      }
      rethrow;
    }
  }

  bool _shouldRetry(http.Response response, int attempt) {
    if (attempt >= retryConfig.maxRetries) return false;

    // Retry on server errors and specific client errors
    return response.statusCode >= 500 || // 5xx errors
        response.statusCode == 408 || // Request Timeout
        response.statusCode == 429; // Too Many Requests
  }

  Future<http.StreamedResponse> _retryRequest(
    http.BaseRequest request,
    int attempt,
  ) async {
    final delay = retryConfig.initialDelay *
        (retryConfig.backoffMultiplier * (attempt + 1));

    debugPrint(
      'Retrying request (${attempt + 1}/${retryConfig.maxRetries}) '
      'after ${delay.inMilliseconds}ms',
    );

    await Future.delayed(delay);
    return _sendWithRetry(request, attempt: attempt + 1);
  }

  // Helper to copy request for retry
  http.BaseRequest _copyRequest(http.BaseRequest request) {
    http.BaseRequest copy;

    if (request is http.Request) {
      copy = http.Request(request.method, request.url)
        ..bodyBytes = request.bodyBytes
        ..encoding = request.encoding;
    } else if (request is http.MultipartRequest) {
      copy = http.MultipartRequest(request.method, request.url)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
    } else {
      throw UnsupportedError(
          'Unsupported request type: ${request.runtimeType}');
    }

    copy.headers.addAll(request.headers);
    copy.persistentConnection = request.persistentConnection;
    copy.followRedirects = request.followRedirects;
    copy.maxRedirects = request.maxRedirects;

    return copy;
  }

  @override
  void close() {
    baseClient.close();
    super.close();
  }
}

/// Base interface for HTTP interceptors
abstract class HttpInterceptor {
  Future<http.BaseRequest> interceptRequest(http.BaseRequest request);
  Future<http.Response> interceptResponse(http.Response response);
}

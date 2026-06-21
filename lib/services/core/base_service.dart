import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sharing_map/services/core/http_client.dart';
import 'package:sharing_map/services/core/models/api_response.dart';
import 'package:sharing_map/utils/constants.dart';

/// Base service class with common CRUD operations
abstract class BaseService<T> {
  final http.Client _client = AppHttpClient().client;

  /// Convert JSON to model
  T fromJson(Map<String, dynamic> json);

  /// Convert model to JSON
  Map<String, dynamic> toJson(T model);

  /// Get base path for the resource
  String get basePath;

  /// Build URI with base URL
  Uri buildUri(String path, [Map<String, dynamic>? queryParams]) {
    return Uri.https(
        Constants.BACK_URL,
        path,
        queryParams?.map(
          (key, value) => MapEntry(key, value.toString()),
        ));
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final uri = buildUri(path, queryParams);
      final response = await _client.get(uri, headers: _defaultHeaders);

      return handleResponse(
        response,
        (json) => fromJson(json as Map<String, dynamic>),
      );
    } on SocketException {
      throw ApiException('network_error', 0);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<T>> getPagedList<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final uri = buildUri(path, queryParams);
      final response = await _client.get(uri, headers: _defaultHeaders);

      return handleResponse(
        response,
        (json) {
          if (json is! Map<String, dynamic>) {
            throw ApiException('expected_object_got_${json.runtimeType}', 200);
          }

          final content = json['content'];
          if (content is! List) {
            throw ApiException('content_not_list', 200);
          }

          return (content)
              .map((e) => fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
    } on SocketException {
      throw ApiException('network_error', 0);
    } catch (e) {
      rethrow;
    }
  }

// For direct array endpoints
  Future<List<T>> getList<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final uri = buildUri(path, queryParams);
      final response = await _client.get(uri, headers: _defaultHeaders);

      return handleResponse(
        response,
        (json) {
          if (json is! List) {
            throw ApiException('expected_list_got_${json.runtimeType}', 200);
          }

          return (json)
              .map((e) => fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
    } on SocketException {
      throw ApiException('network_error', 0);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> postForPlainText(String path, T model,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final uri = buildUri(path, queryParams);
      final body = jsonEncode(toJson(model));

      final response = await _client.post(
        uri,
        headers: _defaultHeaders,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body.trim(); // Return plain text GUID
      } else {
        throw ApiException(
          'Request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('network_error', 0);
    } catch (e) {
      rethrow;
    }
  }

  Future<T> post(String path, T model,
      {Map<String, dynamic>? queryParams,
      T Function(Map<String, dynamic>)? customParser}) async {
    try {
      final uri = buildUri(path, queryParams);
      final body = jsonEncode(toJson(model));

      final response = await _client.post(
        uri,
        headers: _defaultHeaders,
        body: body,
      );

      return handleResponse(
        response,
        (json) => customParser != null
            ? customParser(json)
            : fromJson(json as Map<String, dynamic>),
        expectedStatus: 201,
      );
    } on SocketException {
      throw ApiException('network_error', 0);
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<T> put(String path, T model,
      {Map<String, dynamic>? queryParams, bool haveBody = true}) async {
    try {
      final uri = buildUri(path, queryParams);
      final body = jsonEncode(toJson(model));

      final response = await _client.put(
        uri,
        headers: _defaultHeaders,
        body: body,
      );
      if (haveBody) {
        return handleResponse(
            response, (json) => fromJson(json as Map<String, dynamic>));
      }
      return model;
    } on SocketException {
      throw ApiException('network_error', 0);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final uri = buildUri(path, queryParams);
      final response = await _client.delete(uri, headers: _defaultHeaders);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException('delete_failed', response.statusCode);
      }
    } on SocketException {
      throw ApiException('network_error', 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Handle common HTTP responses
  Future<T> handleResponse<T>(
    http.Response response,
    T Function(dynamic) parser, {
    int expectedStatus = 200,
  }) async {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) {
          throw ApiException('empty_response', response.statusCode);
        }
        try {
          final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
          return parser(jsonData);
        } catch (e) {
          throw ApiException(
              'failed_parse_response', response.statusCode, e.toString());
        }

      case 204:
        return parser(null);

      case 400:
        throw ApiException('invalid_request_data', response.statusCode);

      case 401:
        throw ApiException('unauthorized', response.statusCode);

      case 403:
        throw ApiException('forbidden', response.statusCode);

      case 404:
        throw ApiException('not_found', response.statusCode);

      case 409:
        throw ApiException('conflict', response.statusCode);

      case 500:
        throw ApiException('server_error', response.statusCode);

      default:
        throw ApiException(
          'unexpected_error',
          response.statusCode,
          utf8.decode(response.bodyBytes),
        );
    }
  }

  Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sharing_map/services/core/http_client.dart';

class LoggerInterceptor implements HttpInterceptor {
  @override
  Future<http.BaseRequest> interceptRequest(http.BaseRequest request) async {
    if (kDebugMode) {
      debugPrint('→ ${request.method} ${request.url}');
      debugPrint('  Headers: ${request.headers}');
      if (request is http.Request && request.body.isNotEmpty) {
        debugPrint('  Body: ${request.body}');
      }
    }
    return request;
  }

  @override
  Future<http.Response> interceptResponse(http.Response response) async {
    if (kDebugMode) {
      debugPrint('← ${response.statusCode} ${response.request?.url}');
      debugPrint('  Headers: ${response.headers}');
      if (response.body.isNotEmpty && response.body.length < 1000) {
        debugPrint('  Body: ${response.body}');
      }
    }
    return response;
  }
}

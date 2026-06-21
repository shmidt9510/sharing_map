import 'package:http/http.dart' as http;
import 'package:sharing_map/services/core/http_client.dart';
import 'package:sharing_map/utils/shared.dart';

class AuthInterceptor implements HttpInterceptor {
  @override
  Future<http.BaseRequest> interceptRequest(http.BaseRequest request) async {
    try {
      final authToken = await SharedPrefs().getAuthToken();
      if (authToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }
    } catch (_) {
      // Silently fail - let request proceed without auth
    }
    return request;
  }

  @override
  Future<http.Response> interceptResponse(http.Response response) async {
    return response; // No response processing needed
  }
}

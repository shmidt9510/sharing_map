import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sharing_map/services/core/http_client.dart';
import 'package:sharing_map/utils/constants.dart';
import 'package:sharing_map/utils/shared.dart';

class RefreshTokenInterceptor implements HttpInterceptor {
  static bool _isRefreshing = false;
  @override
  Future<http.BaseRequest> interceptRequest(http.BaseRequest request) async {
    // Skip refresh for refresh token endpoint
    if (request.url.path.contains('/refreshToken')) {
      return request;
    }

    try {
      final authToken = await SharedPrefs().getAuthToken();
      final refreshToken = await SharedPrefs().getRefreshToken();

      if (refreshToken.isEmpty || authToken.isEmpty) {
        return request;
      }

      // Check if token is expired or about to expire (within 1 minute)
      if (_shouldRefreshToken(authToken)) {
        await _refreshToken(refreshToken);
      }
    } catch (e) {
      print('Refresh token interceptor error: $e');
      // Don't fail the request, let it proceed
    }

    return request;
  }

  @override
  Future<http.Response> interceptResponse(http.Response response) async {
    // Handle 401 Unauthorized
    if (response.statusCode == 401) {
      try {
        final refreshToken = await SharedPrefs().getRefreshToken();
        if (refreshToken.isNotEmpty) {
          await _refreshToken(refreshToken);
          // Note: In a real implementation, you'd want to retry the original request
          // This would require more complex state management
        }
      } catch (e) {
        print('Failed to refresh token on 401: $e');
        await SharedPrefs().clear();
      }
    }
    return response;
  }

  bool _shouldRefreshToken(String token) {
    if (token.isEmpty) return false;

    try {
      if (JwtDecoder.isExpired(token)) return true;

      // Refresh if token expires within 1 minute
      final expiryDate = JwtDecoder.getExpirationDate(token);
      final timeUntilExpiry = expiryDate.difference(DateTime.now());
      return timeUntilExpiry.inMinutes < 1;
    } catch (e) {
      return false;
    }
  }

  Future<void> _refreshToken(String refreshToken) async {
    if (_isRefreshing) {
      return Future.value();
    }

    _isRefreshing = true;

    try {
      final response = await http.post(
        Uri.https(Constants.BACK_URL, '/refreshToken'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        SharedPrefs().authToken = jsonData['accessToken'] as String;
        SharedPrefs().refreshToken = jsonData['refreshToken'] as String;
        SharedPrefs().logged = true;
      } else {
        SharedPrefs().refreshToken = '';
        SharedPrefs().authToken = '';
        SharedPrefs().logged = false;
      }
    } catch (e) {
      print('Token refresh failed: $e');
      await SharedPrefs().clear();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }
}

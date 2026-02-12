import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sharing_map/services/core/http_client.dart';
import 'package:sharing_map/services/core/base_service.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/services/photo_service.dart';
import 'package:sharing_map/utils/constants.dart';
import 'package:sharing_map/utils/shared.dart';

class UserService extends BaseService<User> {
  final PhotoService _photoService = PhotoService();
  final http.Client _client = AppHttpClient().client;

  @override
  String get basePath => '/users';

  @override
  User fromJson(Map<String, dynamic> json) => User.fromJson(json);

  @override
  Map<String, dynamic> toJson(User model) => model.toJson();

  /// Login user
  Future<bool> login(String email, String password) async {
    final response = await _client.post(
      buildUri('/login'),
      headers: _defaultHeaders,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final bodyDecoded = jsonDecode(response.body);
      final authToken = bodyDecoded['accessToken'] as String;

      SharedPrefs().logged = true;
      SharedPrefs().authToken = authToken;
      SharedPrefs().refreshToken = bodyDecoded['refreshToken'] as String;

      final decodedToken = JwtDecoder.decode(authToken);
      SharedPrefs().userId = decodedToken['user_id'] as String;

      return true;
    }
    return false;
  }

  /// Sign up new user
  Future<String> signup(String email, String username, String password) async {
    final response = await _client.post(
      buildUri('/signup'),
      headers: _defaultHeaders,
      body: jsonEncode({
        'email': email,
        'password': password,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      final tokenId = jsonData['confirmationTokenId'] as String?;

      if (tokenId == null || tokenId.isEmpty) {
        throw Exception('failed_get_confirmation_token');
      }
      return tokenId;
    } else if (response.statusCode == 400) {
      final errorMessage = utf8.decode(response.bodyBytes);
      if (errorMessage.contains('Email already taken')) {
        return 'email_taken';
      }
      return 'invalid_email';
    }

    throw Exception('failed_with_status_code_${response.statusCode}');
  }

  /// Confirm signup with token
  Future<bool> signupConfirm(String token, String tokenId) async {
    final response = await _client.post(
      buildUri('/signup/confirm'),
      headers: _defaultHeaders,
      body: jsonEncode({
        'token': tokenId,
        'tokenId': token,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('failed_with_status_code_${response.statusCode}');
    }

    final bodyDecoded = jsonDecode(response.body);
    final authToken = bodyDecoded['accessToken'] as String;

    SharedPrefs().logged = true;
    SharedPrefs().authToken = authToken;
    SharedPrefs().refreshToken = bodyDecoded['refreshToken'] as String;

    final decodedToken = JwtDecoder.decode(authToken);
    SharedPrefs().userId = decodedToken['user_id'] as String;

    return true;
  }

  /// Check if user is authenticated
  Future<bool> isAuth() async {
    final response = await _client.get(buildUri('/is_auth'));
    return response.statusCode == 200;
  }

  /// Get user by ID
  Future<User> getUser(String id) async {
    if (id.isEmpty) {
      throw Exception('empty_user_id');
    }
    return get('$basePath/$id', fromJson: User.fromJson);
  }

  /// Update user profile
  Future<bool> updateUser(User user) async {
    await put(
      '$basePath/update',
      user,
      queryParams: {'id': SharedPrefs().userId},
      haveBody: false,
    );
    return true;
  }

  /// Update user photo
  Future<bool> updateUserPhoto(XFile file) async {
    return _photoService.addUserPhotos([file]);
  }

  /// Get user contacts
  Future<List<UserContact>> getUserContact(String id) async {
    if (id.isEmpty) {
      throw Exception('empty_user_id');
    }

    final response = await _client
        .get(
          buildUri('$basePath/$id/contacts'),
          headers: _defaultHeaders,
        )
        .timeout(const Duration(seconds: 5));

    return handleResponse(
      response,
      (json) => (json as List)
          .map((e) => UserContact.fromJson(e as Map<String, dynamic>))
          .toSet()
          .toList(),
    );
  }

  /// Save new contact
  Future<UserContact> saveContact(UserContact contact) async {
    final response = await _client.post(
      buildUri('/contacts/create', {'id': SharedPrefs().userId}),
      headers: _defaultHeaders,
      body: jsonEncode(contact.toJson()),
    );

    return handleResponse(
      response,
      (json) => UserContact.fromJson(json as Map<String, dynamic>),
      expectedStatus: 201,
    );
  }

  /// Update contact
  Future<UserContact> updateContact(UserContact contact) async {
    final response = await _client.put(
      buildUri('/contacts/update', {'id': SharedPrefs().userId}),
      headers: _defaultHeaders,
      body: jsonEncode(contact.toJson()),
    );

    return handleResponse(
      response,
      (json) => UserContact.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Delete contact
  Future<bool> deleteContact(String contactId) async {
    final response = await _client.delete(
      buildUri('/contacts/delete/$contactId'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('failed_with_status_code_${response.statusCode}');
    }
    return true;
  }

  /// Start password reset process
  Future<ResetPasswordStartData> resetPasswordStart(String email) async {
    final response = await _client.post(
      buildUri('/resetPassword'),
      headers: _defaultHeaders,
      body: jsonEncode({'email': email}),
    );

    return handleResponse(
      response,
      (json) => ResetPasswordStartData(
        json['resetPasswordTokenId'] as String,
        json['userId'] as String,
      ),
    );
  }

  /// Confirm password reset
  Future<bool> resetPasswordConfirm(String token, String tokenId) async {
    final response = await _client.post(
      buildUri('/resetPassword/confirm'),
      headers: _defaultHeaders,
      body: jsonEncode({'token': token, 'tokenId': tokenId}),
    );

    if (response.statusCode != 200) {
      throw Exception('failed_with_status_code_${response.statusCode}');
    }
    return true;
  }

  /// Reset password
  Future<bool> resetPassword(
    String token,
    String tokenId,
    String password,
    String userId,
  ) async {
    final response = await _client.post(
      buildUri('/resetPassword/change'),
      headers: _defaultHeaders,
      body: jsonEncode({
        'token': token,
        'tokenId': tokenId,
        'userId': userId,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('failed_with_status_code_${response.statusCode}');
    }
    return true;
  }

  /// Delete current user account
  Future<bool> deleteMyself() async {
    final response = await _client.delete(buildUri('$basePath/delete'));
    return response.statusCode == 200;
  }

  Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}

/// Data class for password reset
class ResetPasswordStartData {
  final String tokenId;
  final String userId;

  ResetPasswordStartData(this.tokenId, this.userId);
}

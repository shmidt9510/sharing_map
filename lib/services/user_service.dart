import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/services/photo_service.dart';

import 'package:sharing_map/utils/constants.dart';
import 'package:sharing_map/utils/shared.dart';
import 'interceptors.dart';

import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';

class UserPass {
  final String password;
  final String email;
  late String? username;
  UserPass(this.email, this.password, {this.username});

  Map<String, dynamic> toJson() => {
        'password': password,
        'email': email,
        'username': username,
      };
}

class ConfirmDTO {
  final String tokenId;
  final String token;
  ConfirmDTO(this.tokenId, this.token);

  Map<String, dynamic> toJson() => {
        'token': tokenId,
        'tokenId': token,
      };
}

class ResetPasswordStartData {
  final String tokenId;
  final String userId;
  ResetPasswordStartData(this.tokenId, this.userId);
}

class UserWebService {
  static var client = InterceptedClient.build(
    interceptors: [
      LoggerInterceptor(),
      RefreshTokenInterceptor(),
      AuthorizationInterceptor(),
    ],
  );

  static Future<bool> login(String email, String password) async {
    // var body = {'email': '$email', 'password': '$password'};
    try {
      var response = await client.post(Uri.https(Constants.BACK_URL, "/login"),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: jsonEncode(UserPass(email, password).toJson()));
      var bodyDecoded = jsonDecode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        SharedPrefs().logged = true;
        SharedPrefs().authToken = bodyDecoded["accessToken"].toString();
        SharedPrefs().refreshToken = bodyDecoded["refreshToken"].toString();
        String authToken = await SharedPrefs().getAuthToken();
        Map<String, dynamic> decodedToken = JwtDecoder.decode(authToken);
        print(decodedToken["user_id"] as String);
        SharedPrefs().userId = decodedToken["user_id"] as String;
      } else {
        return false;
      }
      return true;
    } catch (e) {
      return Future.error("");
    }
  }

  static Future<String> refresh() async {
    var response = await client.get(Uri.https(Constants.BACK_URL, "/signup"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return "";
    }
    return "";
  }

  static Future<String> signup(
      String email, String username, String password) async {
    var response = await client.post(Uri.https(Constants.BACK_URL, "/signup"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body:
            jsonEncode(UserPass(email, password, username: username).toJson()));

    if (response.statusCode == 200) {
      // SharedPrefs().userId = response["user_id"].toString();
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData["confirmationTokenId"].toString().isEmpty) {
        return Future.error("failed_get_confirmation_token");
      }
      return jsonData["confirmationTokenId"].toString();
    } else if (response.statusCode == 400) {
      if (utf8.decode(response.bodyBytes) ==
          "Registration failed. Email already taken.") {
        return "email_taken";
      }
      return "invalid_email";
    } else {
      return Future.error(
          "failed_with_status_code_" + response.statusCode.toString());
    }
  }

  static Future<bool> signupConfirm(String token, String tokenId) async {
    var response =
        await client.post(Uri.https(Constants.BACK_URL, "/signup/confirm"),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
            },
            body: jsonEncode(ConfirmDTO(tokenId, token).toJson()));
    var bodyDecoded = jsonDecode(response.body);
    if (response.statusCode != 200) {
      return Future.error(
          "failed_with_status_code_" + response.statusCode.toString());
    }
    SharedPrefs().logged = true;
    SharedPrefs().authToken = bodyDecoded["accessToken"].toString();
    SharedPrefs().refreshToken = bodyDecoded["refreshToken"].toString();

    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(bodyDecoded["accessToken"].toString());
    SharedPrefs().userId = decodedToken["user_id"] as String;
    return true;
  }

  static Future<bool> isAuth() async {
    try {
      var response =
          await client.get(Uri.https(Constants.BACK_URL, "/is_auth"));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateUser(User user) async {
    var uri = "/users/update";
    var response = await client.put(Uri.https(Constants.BACK_URL, uri),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(user.toJson()),
        params: {"id": SharedPrefs().userId});

    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_create_item");
    }
    return true;
  }

  static Future<bool> updateUserPhoto(XFile file) async {
    PhotoWebService service = PhotoWebService();
    return await service.addPhotos([file], "user");
  }

  static Future<User> getUser(String id) async {
    if (id.isEmpty) {
      return Future.error("empty_user_id");
    }
    var uri = "/users/$id";
    var response =
        await client.get(Uri.https(Constants.BACK_URL, uri), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    });

    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_create_item");
    }
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    return User.fromJson(jsonData);
  }

  static Future<List<UserContact>> getUserContact(String id) async {
    if (id.isEmpty) {
      return Future.error("empty_user_id");
    }
    var uri = "/users/$id/contacts";
    var response =
        await client.get(Uri.https(Constants.BACK_URL, uri), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    }).timeout(Duration(seconds: 5));

    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_create_item");
    }
    return (jsonDecode(utf8.decode(response.bodyBytes)) as List)
        .map((e) => UserContact.fromJson(e))
        .toList();
  }

  static Future<UserContact> saveContact(UserContact contact) async {
    var uri = "/contacts/create";
    var response = await client.post(Uri.https(Constants.BACK_URL, uri),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(contact.toJson()),
        params: {"id": SharedPrefs().userId});
    if (response.statusCode / 200 != 1) {
      return Future.error(
          "failed_with_status_code_" + response.statusCode.toString());
    }
    UserContact newContact =
        UserContact.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return newContact;
  }

  static Future<UserContact> updateContact(UserContact contact) async {
    var uri = "/contacts/update";
    var response = await client.put(Uri.https(Constants.BACK_URL, uri),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(contact.toJson()),
        params: {"id": SharedPrefs().userId});
    if (response.statusCode / 200 != 1) {
      return Future.error(
          "failed_with_status_code_" + response.statusCode.toString());
    }
    UserContact newContact =
        UserContact.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return newContact;
  }

  static Future<bool> deleteContact(String contactId) async {
    var uri = "/contacts/delete/$contactId";
    var response = await client.delete(Uri.https(Constants.BACK_URL, uri));
    if (response.statusCode / 200 != 1) {
      return Future.error(
          "failed_with_status_code_" + response.statusCode.toString());
    }
    return true;
  }

  static Future<ResetPasswordStartData> resetPasswordStart(String email) async {
    var data = {
      'email': email,
    };
    var response =
        await client.post(Uri.https(Constants.BACK_URL, "/resetPassword"),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
            },
            body: jsonEncode(data));

    if (response.statusCode != 200) {
      return Future.error(
          "failed_with_status_code_" + response.statusCode.toString());
    }
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    if (jsonData["resetPasswordTokenId"].toString().isEmpty) {
      return Future.error("failed_get_confirmation_token");
    }
    return ResetPasswordStartData(jsonData["resetPasswordTokenId"].toString(),
        jsonData["userId"].toString());
  }

  static Future<bool> resetPasswordConfirm(String token, String tokenId) async {
    var data = {'token': token, 'tokenId': tokenId};
    var response = await client.post(
        Uri.https(Constants.BACK_URL, "/resetPassword/confirm"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(data));
    if (response.statusCode != 200) {
      return Future.error(
          "failed_with_status_code_" + response.statusCode.toString());
    }
    return true;
  }

  static Future<bool> resetPassword(
      String token, String tokenId, String password, String userId) async {
    var data = {
      'token': token,
      'tokenId': tokenId,
      'userId': userId,
      'password': password
    };
    var response = await client.post(
        Uri.https(Constants.BACK_URL, "/resetPassword/change"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(data));
    if (response.statusCode != 200) {
      return Future.error(
          "failed_with_status_code_" + response.statusCode.toString());
    }
    return true;
  }

  static Future<bool> deleteMyself() async {
    try {
      var response =
          await client.delete(Uri.https(Constants.BACK_URL, "/users/delete"));
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

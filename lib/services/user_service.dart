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

class UserServiceRetryPolicy extends RetryPolicy {
  @override
  int maxRetryAttempts = 2;
}

class UserWebService {
  static var client = InterceptedClient.build(
    requestTimeout: Duration(seconds: 10),
    retryPolicy: UserServiceRetryPolicy(),
    interceptors: [
      LoggerInterceptor(),
      RefreshTokenInterceptor(),
      AuthorizationInterceptor(),
    ],
  );
  static var authlessClient = InterceptedClient.build(
    requestTimeout: Duration(seconds: 10),
    retryPolicy: UserServiceRetryPolicy(),
    interceptors: [
      LoggerInterceptor(),
    ],
  );

  static Future<bool> login(String email, String password) async {
    try {
      await SharedPrefs().setAuthTokenAsync("");
      await SharedPrefs().setRefreshTokenAsync("");
      await SharedPrefs().setLoggedAsync(false);

      var response = await authlessClient.post(Constants.buildUri("/login"),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: jsonEncode(UserPass(email, password).toJson()));
      var bodyDecoded = jsonDecode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        var authToken = bodyDecoded["accessToken"].toString();
        await SharedPrefs().setLoggedAsync(true);
        await SharedPrefs().setAuthTokenAsync(authToken);
        await SharedPrefs()
            .setRefreshTokenAsync(bodyDecoded["refreshToken"].toString());
        Map<String, dynamic> decodedToken = JwtDecoder.decode(authToken);
        await SharedPrefs().setUserIdAsync(decodedToken["user_id"] as String);
      } else {
        return false;
      }
      return true;
    } catch (e) {
      return Future.error("");
    }
  }

  static Future<String> signup(
      String email, String username, String password) async {
    var response = await authlessClient.post(Constants.buildUri("/signup"),
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
        await authlessClient.post(Constants.buildUri("/signup/confirm"),
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
    await SharedPrefs().setLoggedAsync(true);
    await SharedPrefs().setAuthTokenAsync(bodyDecoded["accessToken"].toString());
    await SharedPrefs()
        .setRefreshTokenAsync(bodyDecoded["refreshToken"].toString());

    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(bodyDecoded["accessToken"].toString());
    await SharedPrefs().setUserIdAsync(decodedToken["user_id"] as String);
    return true;
  }

  static Future<bool> isAuth() async {
    var response = await client.get(Constants.buildUri("/is_auth"));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> updateUser(User user) async {
    var uri = "/users/update";
    var response = await client.put(Constants.buildUri(uri),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(user.toJson()),
        params: {"id": SharedPrefs().userId});

    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_updating_user");
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
        await client.get(Constants.buildUri(uri), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    });

    if (response.statusCode == 404) {
      SharedPrefs().clear();
      SharedPrefs().isFirstRun = false;
      return Future.error("no_user_found");
    }
    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_getting_user");
    }
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    return User.fromJson(jsonData);
  }

  static Future<int> getTransferredItemsCount(String id) async {
    if (id.isEmpty) {
      return Future.error("empty_user_id");
    }
    var uri = "/users/$id/transferred-items/count";
    var response =
        await client.get(Constants.buildUri(uri), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    }).timeout(Duration(seconds: 5));

    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_getting_transferred_items_count");
    }
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    return int.tryParse(jsonData["count"].toString()) ?? 0;
  }

  static Future<List<UserContact>> getUserContact(String id) async {
    if (id.isEmpty) {
      return Future.error("empty_user_id");
    }
    var uri = "/users/$id/contacts";
    var response =
        await client.get(Constants.buildUri(uri), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    }).timeout(Duration(seconds: 5));

    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_get_user_contact");
    }
    return (jsonDecode(utf8.decode(response.bodyBytes)) as List)
        .map((e) => UserContact.fromJson(e))
        .toList();
  }

  static Future<UserContact> saveContact(UserContact contact) async {
    var uri = "/contacts/create";
    var response = await client.post(Constants.buildUri(uri),
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
    var response = await client.put(Constants.buildUri(uri),
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
    var response = await client.delete(Constants.buildUri(uri));
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
        await client.post(Constants.buildUri("/resetPassword"),
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
        Constants.buildUri("/resetPassword/confirm"),
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
        Constants.buildUri("/resetPassword/change"),
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
          await client.delete(Constants.buildUri("/users/delete"));
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

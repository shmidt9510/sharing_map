import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/services/photo_service.dart';

import 'package:sharing_map/utils/constants.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:uuid/uuid_util.dart';
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

class UserWebService {
  static var client = InterceptedClient.build(
    interceptors: [
      LoggerInterceptor(),
      AuthorizationInterceptor(),
    ],
  );

  static Future<bool> login(String email, String password) async {
    // var body = {'email': '$email', 'password': '$password'};
    try {
      var response = await client.post(Uri.parse(Constants.BACK_URL + "/login"),
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

        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(SharedPrefs().authToken);
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
    var response = await client.get(Uri.parse(Constants.BACK_URL + "/signup"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return "";
    }
    return "";
  }

  static Future<String> signup(
      String email, String username, String password) async {
    var response = await client.post(Uri.parse(Constants.BACK_URL + "/signup"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body:
            jsonEncode(UserPass(email, password, username: username).toJson()));

    if (response.statusCode == 200) {
      // SharedPrefs().userId = response["user_id"].toString();
      var jsonData = jsonDecode(response.body);
      if (jsonData["confirmationTokenId"].toString().isEmpty) {
        return Future.error("failed_get_confirmation_token");
      }
      return jsonData["confirmationTokenId"].toString();
    } else {
      return Future.error(
          "failed_with_status_code_" + response.statusCode.toString());
    }
  }

  static Future<String> signupConfirm(String token, String tokenId) async {
    var response =
        await client.post(Uri.parse(Constants.BACK_URL + "/signup/confirm"),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
            },
            body: jsonEncode(ConfirmDTO(tokenId, token).toJson()));

    if (response.statusCode == 200) {
      // SharedPrefs().userId = response["user_id"].toString();
      var jsonData = jsonDecode(response.body);
      debugPrint(jsonData);
      // if (jsonData["confirmationTokenId"].toString().isEmpty) {
      //   return Future.error("failed_get_confirmation_token");
      // }
      return jsonData["user_id"].toString();
    } else {
      return Future.error(
          "failed_with_status_code_" + response.statusCode.toString());
    }
  }

  static Future<String> isAuth() async {
    var response =
        await client.get(Uri.parse(Constants.BACK_URL + "/get_token"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return "";
    } else {
      return "";
    }
  }

  static Future<bool> updateUser(User user, XFile? file) async {
    var uri = "/users/update";
    if (file != null) {
      PhotoWebService service = PhotoWebService();
      await service.addPhotos([file], "user"); //TBD
    }

    var response = await client.put(Uri.parse(Constants.BACK_URL + uri),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(user.toJson()));

    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_create_item");
    }
    return true;
  }

  static Future<User> getUser(String id) async {
    if (id.isEmpty) {
      return Future.error("empty_user_id");
    }
    var uri = "/users/info";

    // if (file != null) {
    //   PhotoWebService service = PhotoWebService();
    //   service.addPhotos([file], "user"); //TBD
    // }

    var response =
        await client.get(Uri.parse(Constants.BACK_URL + uri), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    }, params: {
      "id": id
    });

    debugPrint(response.toString());
    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_create_item");
    }

    var jsonData = jsonDecode(response.body);
    var user = User.fromJson(jsonData);
    // return (jsonData as List).map((e) => Item.fromJson(e)).toList();
    return user;
  }
}

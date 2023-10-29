import 'dart:convert';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sharing_map/services/photo_service.dart';

import 'package:sharing_map/utils/constants.dart';
import 'package:sharing_map/utils/shared.dart';
import 'interceptors.dart';

import 'package:sharing_map/models/item.dart';
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
      if (jsonData["id"].toString().isEmpty) {
        return Future.error("failed_get_username");
      }
      return jsonData["id"].toString();
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
}

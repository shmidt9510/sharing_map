import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sharing_map/utils/constants.dart';
import 'package:sharing_map/utils/shared.dart';

class LoggerInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print("----- Request -----");
    print(data.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print("----- Response -----");
    print(data.toString());
    return data;
  }
}

class AuthorizationInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      if (SharedPrefs().authToken.isNotEmpty) {
        data.headers["Authorization"] = "Bearer " + SharedPrefs().authToken;
      }
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class RefreshTokenDTO {
  final String refreshToken;
  RefreshTokenDTO(this.refreshToken);

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}

class RefreshTokenInterceptor implements InterceptorContract {
  static var client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      // debugPrint("onInit");
      // debugPrint(SharedPrefs().authToken);
      // debugPrint(SharedPrefs().refreshToken);
      // debugPrint(SharedPrefs().userId);
      // debugPrint(SharedPrefs().logged.toString());
      if (SharedPrefs().refreshToken.isNotEmpty) {
        if (SharedPrefs().authToken.isEmpty ||
            JwtDecoder.isExpired(SharedPrefs().authToken)) {
          var response = await client.post(
              Uri.parse(Constants.BACK_URL + "/refreshToken"),
              headers: {
                "content-type": "application/json",
                "accept": "application/json",
              },
              body: jsonEncode(
                  RefreshTokenDTO(SharedPrefs().refreshToken).toJson()));
          if (response.statusCode == 200) {
            var jsonData = jsonDecode(response.body);
            SharedPrefs().authToken = jsonData["accessToken"].toString();
            SharedPrefs().refreshToken = jsonData["refreshToken"].toString();
          } else {
            SharedPrefs().authToken = "";
            SharedPrefs().logged = false;
            SharedPrefs().refreshToken = "";
            SharedPrefs().userId = "";
            return Future.error("unuathorized");
          }
        }
      }
    } catch (e) {
      return Future.error("500");
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

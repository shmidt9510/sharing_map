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
    debugPrint("----- Request -----");
    debugPrint(data.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    debugPrint("----- Response -----");
    debugPrint(data.toString());
    return data;
  }
}

class AuthorizationInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      String authToken = await SharedPrefs().getAuthToken();
      if (authToken.isNotEmpty) {
        data.headers["Authorization"] = "Bearer " + authToken;
      }
    } catch (e) {
      debugPrint(e.toString());
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
      String authToken = await SharedPrefs().getAuthToken();
      String refreshToken = await SharedPrefs().getRefreshToken();
      if (refreshToken.isNotEmpty) {
        if (authToken.isEmpty || JwtDecoder.isExpired(authToken)) {
          var response =
              await client.post(Uri.https(Constants.BACK_URL, "/refreshToken"),
                  headers: {
                    "content-type": "application/json",
                    "accept": "application/json",
                  },
                  body: jsonEncode(RefreshTokenDTO(refreshToken).toJson()));
          if (response.statusCode == 200) {
            var jsonData = jsonDecode(response.body);
            SharedPrefs().authToken = jsonData["accessToken"].toString();
            SharedPrefs().refreshToken = jsonData["refreshToken"].toString();
            SharedPrefs().logged = true;
          }
          //  else {
          //   SharedPrefs().authToken = "";
          //   SharedPrefs().logged = false;
          //   SharedPrefs().refreshToken = "";
          //   SharedPrefs().userId = "";
          //   return Future.error("unuathorized");
          // }
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

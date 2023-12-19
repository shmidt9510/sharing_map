import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sharing_map/path.dart';
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
    interceptors: [],
  );
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      debugPrint(SharedPrefs().authToken);
      if (SharedPrefs().authToken.isNotEmpty) {
        debugPrint("AZAZAZA " +
            JwtDecoder.isExpired(SharedPrefs().authToken).toString());
        debugPrint("AZAZAsbfdbdfbdbf " +
            JwtDecoder.getExpirationDate(SharedPrefs().authToken).toString());

        if (JwtDecoder.isExpired(SharedPrefs().authToken)) {
          debugPrint("avknalkjvnvnjsdvkmsadkvma");
          var response = await client.post(
              Uri.parse(Constants.BACK_URL + "/refreshToken"),
              headers: {
                "content-type": "application/json",
                "accept": "application/json",
              },
              body: jsonEncode(
                  RefreshTokenDTO(SharedPrefs().refreshToken).toJson()));
          debugPrint(response.body.toString());
          debugPrint("WHERE IS MY DATA");
          debugPrint("code is " + response.statusCode.toString());
          debugPrint("HAS AUTH TOKEN " + SharedPrefs().authToken);
          if (response.statusCode == 200) {
            debugPrint("K:NVDS:LNVKLNSDKL");
            var jsonData = jsonDecode(response.body);
            debugPrint(jsonData["accessToken"].toString());
            debugPrint(jsonData["refreshToken"].toString());
            SharedPrefs().authToken = jsonData["accessToken"].toString();
            SharedPrefs().refreshToken = jsonData["refreshToken"].toString();
          } else {
            SharedPrefs().authToken = "";
            SharedPrefs().logged = false;
            SharedPrefs().refreshToken = "";
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

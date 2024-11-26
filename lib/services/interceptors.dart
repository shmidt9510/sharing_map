import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sharing_map/utils/constants.dart';
import 'package:sharing_map/utils/shared.dart';

class LoggerInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    // print("----- Request -----");
    // print(request.method +
    //     " " +
    //     request.headers.toString() +
    //     " " +
    //     request.url.toString() +
    //     " " +
    //     (request as Request).body.toString());
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    // print("----- Response -----");
    // print(response.request.toString() +
    //     response.headers.toString() +
    //     response.statusCode.toString());
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return true;
  }
}

class AuthorizationInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    try {
      String authToken = await SharedPrefs().getAuthToken();
      if (authToken.isNotEmpty) {
        request.headers["Authorization"] = "Bearer " + authToken;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return true;
  }
}

class RefreshTokenDTO {
  final String refreshToken;
  RefreshTokenDTO(this.refreshToken);

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}

class RefreshTokenRetryPolicy extends RetryPolicy {
  @override
  int maxRetryAttempts = 3;
}

class RefreshTokenInterceptor implements InterceptorContract {
  static var client = InterceptedClient.build(
    requestTimeout: Duration(seconds: 2),
    retryPolicy: RefreshTokenRetryPolicy(),
    interceptors: [LoggerInterceptor()],
  );
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    try {
      String authToken = await SharedPrefs().getAuthToken();
      String refreshToken = await SharedPrefs().getRefreshToken();
      await Future.delayed(Duration(milliseconds: 10));
      if (refreshToken.isNotEmpty &&
          authToken.isNotEmpty &&
          SharedPrefs().userId.isNotEmpty) {
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
          } else {
            SharedPrefs().refreshToken = "";
          }
        }
      }
    } catch (e) {
      return Future.error("500");
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async {
    return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return true;
  }
}

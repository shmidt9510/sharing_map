import 'package:http_interceptor/http_interceptor.dart';
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

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:sharing_map/items/models/item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';

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

class Constants {
  static const apiKey = 'd4c8d62cc70545b9b687df1845fd0d04';
  static const topHeadlines =
      'https://newsapi.org/v2/everything?q=stock&from=2023-06-09&sortBy=publishedAt&apiKey=$apiKey';
  static const url = "http://localhost:8080";
}

class ItemWebService {
  static var client = InterceptedClient.build(
    interceptors: [
      LoggerInterceptor(),
    ],
  );

  static Future<List<Item>?> fetchItems() async {
    var response = await client.get(Uri.parse(Constants.url + "/get/items"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return (jsonData as List).map((e) => Item.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  // static Future<List<Item>?> fetchItemsQuery(String query) async {
  //   try {
  //     var response = await client.get(Uri.parse(Constants.url + "/get/items"));

  //     if (response.statusCode == 200) {
  //       var jsonData = jsonDecode(response.body);

  //       return (jsonData['items'] as List)
  //           .map((e) => Item.fromJson(e))
  //           .toList();
  //     } else {
  //       return null;
  //     }
  //   } finally {
  //     debugPrint("a");
  //   }
  // }

  static Future<void> addItem(Item item) async {
    var uri = "/items/create";
    debugPrint(jsonEncode(item.toJson()));
    var response = await client.post(Uri.parse(Constants.url + uri),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(item.toJson()));
    if (response.statusCode == HttpStatus.created) {
      debugPrint(response.toString());
      debugPrint(response.body);
      Future.error("bad smth");
    }
    debugPrint(response.body);
    // var jsonData = jsonDecode(response.toString());
    debugPrint(response.toString());
    debugPrint(item.toJson().toString());
  }
}

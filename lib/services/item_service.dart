import 'dart:convert';
import 'dart:io';
import 'package:sharing_map/services/photo_service.dart';

import 'package:sharing_map/utils/constants.dart';
import 'interceptors.dart';

import 'package:sharing_map/models/item.dart';
import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ItemWebService {
  static var client = InterceptedClient.build(
    interceptors: [LoggerInterceptor(), AuthorizationInterceptor()],
  );

  static Future<List<Item>> fetchItems() async {
    var response = await client.get(Uri.parse(Constants.BACK_URL + "/items"));

    if (response.statusCode != 200) {
      return Future.error("failed_get_data");
    }
    var jsonData = jsonDecode(response.body);
    return (jsonData as List).map((e) => Item.fromJson(e)).toList();
  }

  static Future<String> addItem(Item item) async {
    var uri = "/items/create";
    var response = await client.post(Uri.parse(Constants.BACK_URL + uri),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(item.toJson()));

    if (response.statusCode != HttpStatus.created) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_create_item");
    }
    if (item.downloadableImages != null) {
      PhotoWebService service = PhotoWebService();
      service.addPhotos(item.downloadableImages!, response.body.toString());
    }
    return response.body.toString();
  }
}

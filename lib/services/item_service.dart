import 'dart:convert';
import 'dart:io';
import 'package:sharing_map/services/photo_service.dart';

import 'package:sharing_map/utils/constants.dart';
import 'package:sharing_map/utils/shared.dart';
import 'interceptors.dart';

import 'package:sharing_map/models/item.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ItemServiceRetryPolicy extends RetryPolicy {
  @override
  int maxRetryAttempts = 2;
}

class ItemWebService {
  static var client = InterceptedClient.build(
    requestTimeout: Duration(seconds: 2),
    retryPolicy: ItemServiceRetryPolicy(),
    interceptors: [
      LoggerInterceptor(),
      RefreshTokenInterceptor(),
      AuthorizationInterceptor(),
    ],
  );

  static Future<List<Item>> fetchItems(
      {int pageSize = 10,
      int page = 0,
      int itemType = 1,
      userId = null,
      itemFilter = null}) async {
    String uri = "/items/all";
    if (userId != null) {
      uri = "/users/$userId/items";
    }
    var response =
        await client.get(Uri.https(Constants.BACK_URL, uri), params: {
      "size": pageSize,
      "page": page,
      "categoryId": itemFilter ?? 0,
      "cityId": SharedPrefs().chosenCity,
      "subcategoryId": itemType
    });

    if (response.statusCode != 200) {
      return Future.error("failed_get_data");
    }
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    try {
      return (jsonData["content"] as List)
          .map((e) => Item.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error("failed_parse_content");
    }
  }

  static Future<Item> getItem(String itemId) async {
    String uri = "/items/$itemId";
    var response = await client.get(Uri.https(Constants.BACK_URL, uri));

    if (response.statusCode != 200) {
      return Future.error("failed_get_data");
    }
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    try {
      return Item.fromJson(jsonData);
    } catch (e) {
      return Future.error("failed_parse_content");
    }
  }

  static Future<String> addItem(Item item) async {
    var uri = "/items/create";
    var response = await client.post(Uri.https(Constants.BACK_URL, uri),
        params: {"id": SharedPrefs().userId},
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
      await service.addPhotos(
          item.downloadableImages!, response.body.toString());
    }
    return response.body.toString();
  }

  static Future<bool> deleteItem(String itemId, bool fromSharingMap) async {
    var uri = "/items/delete/$itemId";
    var response = await client.delete(
      Uri.https(Constants.BACK_URL, uri),
      params: {"id": SharedPrefs().userId, "isGiftedOnSm": "$fromSharingMap"},
    );

    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return false;
    }
    return true;
  }

  static Future<bool> updateItem(Item item) async {
    var uri = "/items/update";
    var response = await client.put(Uri.https(Constants.BACK_URL, uri),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(item.toJson()));
    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return Future.error("failed_create_item");
    }
    // TODO^ edit photos
    // if (item.downloadableImages != null) {
    //   PhotoWebService service = PhotoWebService();
    //   await service.addPhotos(
    //       item.downloadableImages!, response.body.toString());
    // }
    return true;
  }
}

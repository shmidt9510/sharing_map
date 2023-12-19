import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sharing_map/utils/constants.dart';

import 'interceptors.dart';

import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/models/category.dart';
import 'package:sharing_map/models/subcategory.dart';
import 'package:sharing_map/models/city.dart';
import 'package:http_interceptor/http_interceptor.dart';

class CommonWebService {
  static var client = InterceptedClient.build(
    interceptors: [
      RefreshTokenInterceptor(),
      LoggerInterceptor(),
      AuthorizationInterceptor()
    ],
  );

  static Future<List<ItemCategory>?> fetchCategories() async {
    var response =
        await client.get(Uri.parse(Constants.BACK_URL + "/categories/all"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      return (jsonData as List).map((e) => ItemCategory.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  static Future<List<Subcategory>?> fetchSubcategories() async {
    final dio = Dio();

    var response =
        await client.get(Uri.parse(Constants.BACK_URL + "/subcategories/all"));
    if (response.statusCode == 200) {
      var jsonData = json.decode(utf8.decode(response.bodyBytes));
      // debugPrint(utf8.decode(response.bodyBytes));
      return (jsonData as List).map((e) => Subcategory.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  static Future<List<City>?> fetchCities() async {
    var response =
        await client.get(Uri.parse(Constants.BACK_URL + "/cities/all"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return (jsonData as List).map((e) => City.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  static Future<List<SMLocation>?> fetchLocations(int cityId) async {
    var response = await client
        .get(Uri.parse(Constants.BACK_URL + "/locations/$cityId/all"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return (jsonData as List).map((e) => SMLocation.fromJson(e)).toList();
    } else {
      return null;
    }
  }
}

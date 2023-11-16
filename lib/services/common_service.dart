import 'dart:convert';
import 'package:sharing_map/utils/constants.dart';

import 'interceptors.dart';

import 'package:sharing_map/models/category.dart';
import 'package:sharing_map/models/subcategory.dart';
import 'package:sharing_map/models/city.dart';
import 'package:http_interceptor/http_interceptor.dart';

class CommonWebService {
  static var client = InterceptedClient.build(
    interceptors: [
      LoggerInterceptor(),
    ],
  );

  static Future<List<ItemCategory>?> fetchCategories() async {
    var response =
        await client.get(Uri.parse(Constants.BACK_URL + "/categories/all"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return (jsonData as List).map((e) => ItemCategory.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  static Future<List<Subcategory>?> fetchSubcategories() async {
    var response =
        await client.get(Uri.parse(Constants.BACK_URL + "/subcategories/all"));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return (jsonData as List).map((e) => Subcategory.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  static Future<List<City>?> fetchCities() async {
    var response =
        await client.get(Uri.parse(Constants.BACK_URL + "/cities/all"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return (jsonData as List).map((e) => City.fromJson(e)).toList();
    } else {
      return null;
    }
  }
}

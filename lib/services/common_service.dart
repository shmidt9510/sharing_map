import 'dart:convert';
import 'interceptors.dart';
import 'constants.dart';

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
    var response = await client.get(Uri.parse(Constants.url + "/categories"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return (jsonData as List).map((e) => ItemCategory.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  static Future<List<Subcategory>?> fetchSubcategories() async {
    var response =
        await client.get(Uri.parse(Constants.url + "/subcategories"));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return (jsonData as List).map((e) => Subcategory.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  static Future<List<City>?> fetchCities() async {
    var response = await client.get(Uri.parse(Constants.url + "/cities"));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return (jsonData as List).map((e) => City.fromJson(e)).toList();
    } else {
      return null;
    }
  }
}

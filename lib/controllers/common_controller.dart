import 'package:flutter/material.dart';
import 'package:sharing_map/models/category.dart';
import 'package:sharing_map/models/subcategory.dart';
import 'package:sharing_map/models/city.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/services/common_service.dart';
import 'package:get/get.dart';

class CommonController extends GetxController {
  var categories = <ItemCategory>[].obs;
  var subcategories = <Subcategory>[].obs;
  var cities = <City>[].obs;
  var locations = <SMLocation>[].obs;
  Map<int, SMLocation> locationsMap = {};

  Future<void> fetchItems() async {
    if (categories.isNotEmpty &&
        subcategories.isNotEmpty &&
        cities.isNotEmpty) {
      return;
    }
    final (categoriesTemp, subcategoriesTemp, citiesTemp) = await (
      CommonWebService.fetchCategories(),
      CommonWebService.fetchSubcategories(),
      CommonWebService.fetchCities()
    ).wait;
    if (categoriesTemp != null) {
      categories(categoriesTemp);
    }
    if (subcategoriesTemp != null) {
      subcategories(subcategoriesTemp);
    }
    if (citiesTemp != null) {
      cities(citiesTemp);
    }
  }

  Future<void> getLocations(int cityId, bool cityChanged) async {
    if (locations.isNotEmpty && !cityChanged) {
      return;
    }
    var locationsTemp = await CommonWebService.fetchLocations(cityId);
    if (locationsTemp != null) {
      locationsTemp.forEach((element) {
        locationsMap[element.id] = element;
      });
      locations(locationsTemp);
    }
  }

  Future<bool> checkInternet() async {
    try {
      return await CommonWebService.checkInternetConnectivity();
    } catch (e) {
      return false;
    }
  }

  var categoriesAssetsName = {
    'all': true,
    'appliance': true,
    'auto': true,
    'beauty_bath': true,
    'beauty_cosmetics': true,
    'books': true,
    'child': true,
    'clothes': true,
    'dacha': true,
    'favorite': true,
    'food': true,
    'hand': true,
    'health': true,
    'hobby': true,
    'home': true,
    'other': true,
    'pets': true,
    'plants': true,
    'renovation': true,
    'sport': true,
    'tourism': true,
  };

  AssetImage chooseCategorieImage(ItemCategory category) {
    String assetName = "other";
    if (categoriesAssetsName.containsKey(category.name)) {
      assetName = category.name;
    }
    return AssetImage("assets/images/categories/$assetName.png");
  }
}

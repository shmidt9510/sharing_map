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

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchItems() async {
    try {
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
    } catch (e) {
      return Future.error("fetch_common_objects_go_wrong: " + e.toString());
    }
  }

  void onRefresh() async {
    fetchItems();
  }

  Future<void> getLocations(int cityId) async {
    try {
      var locationsTemp = await CommonWebService.fetchLocations(cityId);
      if (locationsTemp != null) {
        locationsTemp.forEach((element) {
          locationsMap[element.id] = element;
        });
        locations(locationsTemp);
      }
    } catch (e) {
      return Future.error("error_getting_locations");
    }
  }

  Future<bool> checkInternet() async {
    return await CommonWebService.checkInternetConnectivity();
  }
}

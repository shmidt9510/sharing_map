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
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      var categoriesTemp = await CommonWebService.fetchCategories();
      if (categoriesTemp != null) {
        categories(categoriesTemp);
      }
      var subcategoriesTemp = await CommonWebService.fetchSubcategories();
      if (subcategoriesTemp != null) {
        subcategories(subcategoriesTemp);
      }
      var citiesTemp = await CommonWebService.fetchCities();
      if (citiesTemp != null) {
        cities(citiesTemp);
      }
    } catch (e) {
      return Future.error("fetch_common_objects_go_wrong");
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
}

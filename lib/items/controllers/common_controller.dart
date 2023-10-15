import 'package:sharing_map/items/models/category.dart';
import 'package:sharing_map/items/models/subcategory.dart';
import 'package:sharing_map/items/models/city.dart';
import 'package:sharing_map/items/services/common_service.dart';
import 'package:get/get.dart';

class CommonController extends GetxController {
  var categories = <ItemCategory>[].obs;
  var subcategories = <Subcategory>[].obs;
  var cities = <City>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  void fetchItems() async {
    isLoading(true);

    try {
      isLoading(true);
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
    } finally {
      isLoading(false);
    }
  }

  void onRefresh() async {
    fetchItems();
  }
}

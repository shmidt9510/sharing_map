import 'package:sharing_map/items/models/item.dart';
import 'package:sharing_map/items/services/item_service.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  var items = <Item>[].obs;
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
      var itemTemp = await ItemWebService.fetchItems();
      if (itemTemp != null) {
        items(itemTemp);
      }
    } finally {
      isLoading(false);
    }
  }

  void onRefresh() async {
    fetchItems();
  }

  // void fetchQuery(String query) async {
  //   isLoading(true);

  //   try {
  //     isLoading(true);
  //     var articleTemp = await ItemWebService.fetchItemsQuery(query);
  //     if (articleTemp != null) {
  //       articles(articleTemp);
  //     }
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  void addItem(Item item) async {
    isLoading(true);

    try {
      isLoading(true);
      var response = await ItemWebService.addItem(item);
    } finally {
      isLoading(false);
    }
  }
}

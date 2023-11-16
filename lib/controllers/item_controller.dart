import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/services/item_service.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  var items = <Item>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems().then((value) => printInfo());
  }

  Future<void> fetchItems() async {
    isLoading(true);
    try {
      isLoading(true);
      var itemTemp = await ItemWebService.fetchItems();
      items(itemTemp);
    } catch (e) {
      Future.error("no_data");
    } finally {
      isLoading(false);
    }
  }

  Future<RxList<Item>> waitItem() async {
    await fetchItems();
    return items;
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
      if (response.isEmpty) {
        isLoading(false);
      }
    } finally {
      isLoading(false);
    }
  }
}

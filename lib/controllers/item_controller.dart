import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/services/item_service.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  var items = <Item>[].obs;

  void dropItems() {
    items.clear();
  }

  Future<List<Item>> fetchItems(
      {int pageSize = 10,
      int page = 0,
      String? userId = null,
      int? itemFilter}) async {
    try {
      var itemTemp = await ItemWebService.fetchItems(
          pageSize: pageSize,
          page: page,
          userId: userId,
          itemFilter: itemFilter);
      items.addAll(itemTemp);
      return itemTemp;
    } catch (e) {
      return Future.error("no_data");
    }
  }

  Future<RxList<Item>> waitItem() async {
    await fetchItems();
    return items;
  }

  void onRefresh() async {
    fetchItems();
  }

  Future<bool> addItem(Item item) async {
    try {
      var response = await ItemWebService.addItem(item);
      if (response.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteItem(String itemId) async {
    try {
      return await ItemWebService.deleteItem(itemId);
    } catch (e) {
      return false;
    }
  }
}

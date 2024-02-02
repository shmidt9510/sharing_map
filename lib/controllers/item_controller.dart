import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/services/item_service.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  var items = <Item>[].obs;

  final Map<int, PagingController<int, Item>> pagingControllers = {};

  @override
  void onInit() async {
    super.onInit();
    final categories = Get.find<CommonController>().categories;
    for (int i = 0; i < categories.length; i++) {
      pagingControllers[categories[i].id] = PagingController(firstPageKey: 0);
    }
  }

  @override
  void dispose() {
    pagingControllers.forEach((k, v) => v.dispose());
    super.dispose();
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
      pagingControllers.forEach((key, value) => value.refresh());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteItem(String itemId) async {
    try {
      var result = await ItemWebService.deleteItem(itemId);
      pagingControllers.forEach((key, value) => value.refresh());
      return result;
    } catch (e) {
      return false;
    }
  }
}

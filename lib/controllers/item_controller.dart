import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/services/item_service.dart';
import 'package:get/get.dart';
import 'package:sharing_map/utils/shared.dart';

class ItemController extends GetxController {
  static const _pageSize = 20;

  final Map<int, PagingController<int, Item>> givePagingControllers = {};
  final Map<int, PagingController<int, Item>> getPagingControllers = {};
  late PagingController<int, Item> userPagingController;

  @override
  void onInit() async {
    super.onInit();
    userPagingController = PagingController(firstPageKey: 0);
    userPagingController.addPageRequestListener((pageKey) {
      _fetchUserPage(pageKey);
    });
  }

  Future<bool> onSplashScreen() async {
    final categories = Get.find<CommonController>().categories;
    if (categories.isEmpty) {
      return Future.error("");
    }
    for (int i = 0; i < categories.length; i++) {
      givePagingControllers[categories[i].id] =
          PagingController(firstPageKey: 0);
      givePagingControllers[categories[i].id]
          ?.addPageRequestListener((pageKey) {
        _fetchGivePage(pageKey, categories[i].id);
      });

      getPagingControllers[categories[i].id] =
          PagingController(firstPageKey: 0);
      getPagingControllers[categories[i].id]?.addPageRequestListener((pageKey) {
        _fetchGetPage(pageKey, categories[i].id);
      });
    }
    return true;
  }

  @override
  void dispose() {
    givePagingControllers.forEach((k, v) => v.dispose());
    getPagingControllers.forEach((k, v) => v.dispose());
    super.dispose();
  }

  Future<void> _fetchUserPage(int pageKey) async {
    try {
      final newItems = await fetchItems(
          page: pageKey,
          pageSize: _pageSize,
          itemType: 0,
          userId: SharedPrefs().userId);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        userPagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        userPagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      userPagingController.error = error;
    }
  }

  Future<void> _fetchGivePage(int pageKey, int itemFilter) async {
    try {
      final newItems = await fetchItems(
          page: pageKey,
          pageSize: _pageSize,
          itemFilter: itemFilter,
          itemType: 1);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        givePagingControllers[itemFilter]?.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        givePagingControllers[itemFilter]?.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      givePagingControllers[itemFilter]?.error = error;
    }
  }

  Future<void> _fetchGetPage(int pageKey, int itemFilter) async {
    try {
      final newItems = await fetchItems(
          page: pageKey,
          pageSize: _pageSize,
          itemFilter: itemFilter,
          itemType: 2);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        getPagingControllers[itemFilter]?.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        getPagingControllers[itemFilter]?.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      getPagingControllers[itemFilter]?.error = error;
    }
  }

  Future<List<Item>> fetchItems(
      {int pageSize = 10,
      int page = 0,
      String? userId = null,
      int? itemFilter,
      int itemType = 1}) async {
    try {
      var itemTemp = await ItemWebService.fetchItems(
          pageSize: pageSize,
          page: page,
          userId: userId,
          itemFilter: itemFilter,
          itemType: itemType);
      // items.addAll(itemTemp);
      return itemTemp;
    } catch (e) {
      return Future.error("no_data");
    }
  }

  Future<Item> GetItem(String itemId) async {
    try {
      return await ItemWebService.getItem(itemId);
    } catch (e) {
      return Future.error("no_data");
    }
  }

  void refershAll() {
    givePagingControllers.forEach((key, value) {
      value.itemList = [];
      value.refresh();
    });
    getPagingControllers.forEach((key, value) {
      value.itemList = [];
      value.refresh();
    });
    userPagingController.refresh();
  }

  Future<bool> addItem(Item item) async {
    try {
      var response = await ItemWebService.addItem(item);
      if (response.isEmpty) {
        return false;
      }
      refershAll();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateItem(Item item) async {
    try {
      var success = await ItemWebService.updateItem(item);
      if (!success) {
        return false;
      }
      refershAll();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteItem(String itemId, bool fromSharingMap) async {
    try {
      var result = await ItemWebService.deleteItem(itemId, fromSharingMap);
      refershAll();
      return result;
    } catch (e) {
      return false;
    }
  }
}

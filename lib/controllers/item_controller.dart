import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/services/item_service.dart';
import 'package:get/get.dart';
import 'package:sharing_map/utils/shared.dart';

class ItemController extends GetxController {
  static const _pageSize = 20;

  final Map<int, PagingController<int, Item>> pagingControllers = {};
  late PagingController<int, Item> userPagingController;

  @override
  void onInit() async {
    super.onInit();
    userPagingController = PagingController(firstPageKey: 0);
    userPagingController.addPageRequestListener((pageKey) {
      _fetchUserPage(pageKey);
    });
    final categories = Get.find<CommonController>().categories;
    for (int i = 0; i < categories.length; i++) {
      pagingControllers[categories[i].id] = PagingController(firstPageKey: 0);
      pagingControllers[categories[i].id]?.addPageRequestListener((pageKey) {
        _fetchPage(pageKey, categories[i].id);
      });
    }
  }

  @override
  void dispose() {
    pagingControllers.forEach((k, v) => v.dispose());
    super.dispose();
  }

  Future<void> _fetchUserPage(int pageKey) async {
    try {
      final newItems = await fetchItems(
          page: pageKey, pageSize: _pageSize, userId: SharedPrefs().userId);

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

  Future<void> _fetchPage(int pageKey, int itemFilter) async {
    try {
      final newItems = await fetchItems(
          page: pageKey, pageSize: _pageSize, itemFilter: itemFilter);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingControllers[itemFilter]?.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingControllers[itemFilter]?.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingControllers[itemFilter]?.error = error;
    }
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
    pagingControllers.forEach((key, value) {
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

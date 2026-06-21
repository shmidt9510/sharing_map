import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/services/item_service.dart';
import 'package:get/get.dart';
import 'package:sharing_map/utils/shared.dart';

class ItemController extends GetxController {
  static const _pageSize = 20;
  final ItemService _itemService = ItemService();

  final Map<int, PagingController<int, Item>> givePagingControllers = {};
  final Map<int, PagingController<int, Item>> getPagingControllers = {};
  late PagingController<int, Item> userPagingController;

  @override
  void onInit() {
    super.onInit();
    debugPrint(SharedPrefs().userId);
    userPagingController = _createUserPagingController(
      userId: SharedPrefs().userId,
      itemType: 0,
    );
  }

  Future<bool> onSplashScreen() async {
    final categories = Get.find<CommonController>().categories;
    if (categories.isEmpty) {
      return Future.error("");
    }

    for (final category in categories) {
      givePagingControllers[category.id] = _createPagingController(
        itemFilter: category.id,
        itemType: 1,
      );

      getPagingControllers[category.id] = _createPagingController(
        itemFilter: category.id,
        itemType: 2,
      );
    }
    return true;
  }

  PagingController<int, Item> _createPagingController({
    int? itemFilter,
    required int itemType,
  }) {
    return PagingController<int, Item>(
      getNextPageKey: (state) {
        if (state.lastPageIsEmpty) return null;

        final lastPage = state.pages?.lastOrNull;
        if (lastPage != null && lastPage.length < _pageSize) {
          return null;
        }

        return state.nextIntPageKey;
      },
      fetchPage: (pageKey) async {
        final items = await getItemsList(
          page: pageKey - 1,
          pageSize: _pageSize,
          itemFilter: itemFilter,
          itemType: itemType,
        );

        debugPrint("✅ Received ${items.length} items");
        return items;
      },
    );
  }

  PagingController<int, Item> _createUserPagingController({
    required String userId,
    int? itemFilter,
    required int itemType,
  }) {
    return PagingController<int, Item>(
      getNextPageKey: (state) {
        if (state.lastPageIsEmpty) return null;

        final lastPage = state.pages?.lastOrNull;
        if (lastPage != null && lastPage.length < _pageSize) {
          return null;
        }

        return state.nextIntPageKey;
      },
      fetchPage: (pageKey) async {
        final items = await getUserItemsList(
          userId: userId,
          page: pageKey - 1,
          pageSize: _pageSize,
          itemFilter: itemFilter,
          itemType: itemType,
        );

        debugPrint("✅ Received ${items.length} items");
        return items;
      },
    );
  }

  PagingController<int, Item> createOtherUserController(String userId) {
    debugPrint(userId);
    return _createUserPagingController(
      userId: userId,
      itemType: 0,
    );
  }

  @override
  void dispose() {
    givePagingControllers.forEach((k, v) => v.dispose());
    getPagingControllers.forEach((k, v) => v.dispose());
    userPagingController.dispose();
    super.dispose();
  }

  Future<List<Item>> getItemsList({
    int pageSize = 10,
    int page = 0,
    int? itemFilter,
    int itemType = 1,
  }) async {
    debugPrint("the page is ${page}");
    try {
      return await _itemService.fetchItems(
        pageSize: pageSize,
        page: page,
        itemFilter: itemFilter,
        itemType: itemType,
      );
    } catch (e) {
      return Future.error("fetch_item_no_data");
    }
  }

  Future<List<Item>> getUserItemsList({
    int pageSize = 10,
    int page = 0,
    required String userId,
    int? itemFilter,
    int itemType = 1,
  }) async {
    debugPrint("the page is ${page}");
    try {
      return await _itemService.fetchUserItems(
        userId: userId,
        pageSize: pageSize,
        page: page,
        itemFilter: itemFilter,
        itemType: itemType,
      );
    } catch (e) {
      return Future.error("fetch_item_no_data");
    }
  }

  Future<Item> GetItem(String itemId) async {
    try {
      return await _itemService.getItem(itemId);
    } catch (e) {
      return Future.error("get_item_no_data");
    }
  }

  void refreshAll() {
    givePagingControllers.forEach((key, value) => value.refresh());
    getPagingControllers.forEach((key, value) => value.refresh());
    userPagingController.refresh();
  }

  Future<bool> addItem(Item item) async {
    try {
      var response = await _itemService.addItem(item);
      if (response.isEmpty) {
        debugPrint("empty response");
        return false;
      }
      refreshAll();
      return true;
    } catch (e) {
      debugPrint("error here");
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateItem(Item item) async {
    try {
      var success = await _itemService.updateItem(item);
      if (!success) {
        return false;
      }
      refreshAll();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteItem(String itemId, bool fromSharingMap) async {
    try {
      var result = await _itemService.deleteItem(itemId, fromSharingMap);
      refreshAll();
      return result;
    } catch (e) {
      return false;
    }
  }
}

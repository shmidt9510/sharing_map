import 'package:sharing_map/services/core/base_service.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/services/photo_service.dart';
import 'package:sharing_map/utils/shared.dart';

class ItemService extends BaseService<Item> {
  final PhotoService _photoService = PhotoService();

  @override
  String get basePath => '/items';

  @override
  Item fromJson(Map<String, dynamic> json) => Item.fromJson(json);

  @override
  Map<String, dynamic> toJson(Item model) => model.toJson();

  Future<List<Item>> fetchItems({
    int pageSize = 10,
    int page = 0,
    int itemType = 1,
    int? itemFilter,
  }) async {
    final path = '$basePath/all';

    return await getPagedList<Item>(
      path,
      queryParams: {
        'size': pageSize,
        'page': page,
        'categoryId': itemFilter ?? 0,
        'cityId': SharedPrefs().chosenCity,
        'subcategoryId': itemType,
      },
      fromJson: Item.fromJson,
    );
  }

  Future<List<Item>> fetchUserItems({
    required String userId,
    int pageSize = 10,
    int page = 0,
    int itemType = 1,
    int? itemFilter,
  }) async {
    final path = '/users/$userId/items';

    return await getPagedList<Item>(
      path,
      queryParams: {
        'size': pageSize,
        'page': page,
        'categoryId': itemFilter ?? 0,
        'cityId': SharedPrefs().chosenCity,
        'subcategoryId': itemType,
      },
      fromJson: Item.fromJson,
    );
  }

  Future<Item> getItem(String itemId) async {
    return get('$basePath/$itemId', fromJson: Item.fromJson);
  }

  Future<String> addItem(Item item) async {
    final itemId = await postForPlainText(
      '$basePath/create',
      item,
      queryParams: {'id': SharedPrefs().userId},
    );

    // Upload photos if present
    if (item.downloadableImages != null &&
        item.downloadableImages!.isNotEmpty) {
      try {
        await _photoService.addPhotos(
          item.downloadableImages!,
          itemId,
        );
      } catch (e) {
        print('Failed to upload photos: $e');
        // Don't fail the entire operation if photo upload fails
      }
    }

    return itemId;
  }

  /// Update existing item
  Future<bool> updateItem(Item item) async {
    await put('$basePath/update', item);

    // TODO: Implement photo update logic
    // if (item.downloadableImages != null && item.downloadableImages!.isNotEmpty) {
    //   await _photoService.updatePhotos(item.downloadableImages!, item.id!);
    // }

    return true;
  }

  /// Delete item
  Future<bool> deleteItem(String itemId, bool fromSharingMap) async {
    await delete(
      '$basePath/delete/$itemId',
      queryParams: {
        'id': SharedPrefs().userId,
        'isGiftedOnSm': fromSharingMap.toString(),
      },
    );
    return true;
  }
}

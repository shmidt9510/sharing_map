import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/widgets/paginated_item_list.dart';

class ItemsGetListView extends StatelessWidget {
  final int itemFilter;

  const ItemsGetListView({
    Key? key,
    this.itemFilter = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemsController = Get.find<ItemController>();

    return PaginatedItemList(
      pagingController: itemsController.getPagingControllers[itemFilter]!,
      listType: ItemListType.get,
    );
  }
}

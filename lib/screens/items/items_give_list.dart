import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/widgets/paginated_item_list.dart';

class ItemsGiveListView extends StatelessWidget {
  final int itemFilter;

  const ItemsGiveListView({
    Key? key,
    this.itemFilter = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemsController = Get.find<ItemController>();

    return PaginatedItemList(
      pagingController: itemsController.givePagingControllers[itemFilter]!,
      listType: ItemListType.give,
    );
  }
}

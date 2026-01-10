import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/widgets/paginated_item_list.dart';

class ItemsListViewSelfProfile extends StatelessWidget {
  const ItemsListViewSelfProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemsController = Get.find<ItemController>();

    return PaginatedItemList(
      pagingController: itemsController.userPagingController,
      listType: ItemListType.selfProfile,
      useGoRouter: false,
    );
  }
}

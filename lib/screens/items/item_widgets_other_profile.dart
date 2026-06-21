import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/widgets/paginated_item_list.dart';

class ItemsListViewOtherProfile extends StatelessWidget {
  final String userId;

  const ItemsListViewOtherProfile(
    this.userId, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemsController = Get.find<ItemController>();

    return PaginatedItemList(
      pagingController: itemsController.createOtherUserController(userId),
      listType: ItemListType.otherProfile,
      useGoRouter: false,
      shouldDisposeController: true,
    );
  }
}

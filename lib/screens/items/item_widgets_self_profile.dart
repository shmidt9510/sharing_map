import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/screens/items/item_actions.dart';
import 'package:sharing_map/screens/items/item_detail_page.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/widgets/item_block.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemsListViewSelfProfile extends StatefulWidget {
  const ItemsListViewSelfProfile({Key? key}) : super(key: key);

  @override
  _ItemsListViewSelfProfileState createState() =>
      _ItemsListViewSelfProfileState();
}

class _ItemsListViewSelfProfileState extends State<ItemsListViewSelfProfile> {
  ItemController _itemsController = Get.find<ItemController>();
  CommonController _commonController = Get.find<CommonController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => PagedListView<int, Item>.separated(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        pagingController: _itemsController.userPagingController,
        builderDelegate: PagedChildBuilderDelegate<Item>(
          firstPageErrorIndicatorBuilder: (_) => Center(
            child: Column(children: [
              Image.asset('assets/images/no_data_placeholder.png'),
            ]),
          ),
          newPageErrorIndicatorBuilder: (_) => Center(
            child: Column(children: [
              Image.asset('assets/images/no_data_placeholder.png'),
              Text("Здесь пока ничего нет")
            ]),
          ),
          noItemsFoundIndicatorBuilder: (_) => Center(
            child: Column(children: [
              Image.asset('assets/images/no_data_placeholder.png'),
              Text("Здесь пока ничего нет")
            ]),
          ),
          animateTransitions: true,
          itemBuilder: (context, item, index) => InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemDetailPage(item.id)));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Stack(
                  children: [
                    ItemBlock(item),
                    Positioned(
                      top: 3,
                      right: 3,
                      child: ItemActionsWidget(item),
                    )
                  ],
                ),
              )),
        ),
        separatorBuilder: (context, index) => Container(
          height: 10,
        ),
      );

  @override
  void dispose() {
    super.dispose();
  }
}

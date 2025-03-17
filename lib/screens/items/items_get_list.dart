import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/item_get_block.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemsGetListView extends StatefulWidget {
  final int itemFilter;
  const ItemsGetListView({
    Key? key,
    this.itemFilter = 0,
  }) : super(key: key);

  @override
  _ItemsListViewState createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<ItemsGetListView> {
  ItemController _itemsController = Get.find<ItemController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => PagedListView<int, Item>.separated(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        pagingController:
            _itemsController.getPagingControllers[widget.itemFilter] ??
                PagingController(firstPageKey: 0),
        builderDelegate: PagedChildBuilderDelegate<Item>(
          firstPageErrorIndicatorBuilder: (_) => Center(
            child: Column(children: [
              Icon(Icons.error_outline_sharp, color: MColors.red1),
              Text("Ошибка, попробуйте обновить позднее")
            ]),
          ),
          newPageErrorIndicatorBuilder: (_) => Center(
            child: Column(children: [
              Icon(Icons.error_outline_sharp, color: MColors.red1),
              Text("Ошибка, попробуйте обновить позднее")
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
                GoRouter.of(context).go(
                  SMPath.home + "/item/${item.id}",
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: ItemGetBlock(item),
              )),
        ),
        separatorBuilder: (context, index) => Container(
          height: 10,
        ),
      );
}

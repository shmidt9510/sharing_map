import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/screens/items/item_detail_page.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/widgets/item_block.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemsListView extends StatefulWidget {
  final int itemFilter;
  const ItemsListView({
    Key? key,
    this.itemFilter = 0,
  }) : super(key: key);

  @override
  _ItemsListViewState createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<ItemsListView> {
  static const _pageSize = 20;

  ItemController _itemsController = Get.find<ItemController>();

  @override
  void initState() {
    super.initState();
    _itemsController.pagingControllers[widget.itemFilter]
        ?.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, widget.itemFilter);
    });
  }

  Future<void> _fetchPage(int pageKey, int itemFilter) async {
    try {
      final newItems = await _itemsController.fetchItems(
          page: pageKey, pageSize: _pageSize, itemFilter: itemFilter);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _itemsController.pagingControllers[widget.itemFilter]
            ?.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _itemsController.pagingControllers[widget.itemFilter]
            ?.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _itemsController.pagingControllers[widget.itemFilter]?.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => PagedListView<int, Item>.separated(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        pagingController:
            _itemsController.pagingControllers[widget.itemFilter] ??
                PagingController(firstPageKey: 0),
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
                        builder: (context) => ItemDetailPage(item)));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: ItemBlock(item),
              )),
        ),
        separatorBuilder: (context, index) => Container(
          height: 10,
        ),
      );
}

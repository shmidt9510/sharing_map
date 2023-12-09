import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/screens/items/item_detail_page.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/widgets/item_block.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemsListView extends StatefulWidget {
  final String? userId;
  final int? itemFilter;
  const ItemsListView({Key? key, this.userId = null, this.itemFilter = null})
      : super(key: key);

  @override
  _ItemsListViewState createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<ItemsListView> {
  static const _pageSize = 20;

  ItemController _itemsController = Get.find<ItemController>();

  final PagingController<int, Item> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    debugPrint("onInit");
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, widget.itemFilter ?? 0);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey, int itemFilter) async {
    try {
      final newItems = await _itemsController.fetchItems(
          page: pageKey,
          pageSize: _pageSize,
          userId: widget.userId,
          itemFilter: itemFilter);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, Item>.separated(
          // scrollDirection: Axis.vertical,
          shrinkWrap: true,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Item>(
            animateTransitions: true,
            itemBuilder: (context, item, index) => InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemDetailPage(item)));
                },
                child: ItemBlock(item)),
          ),
          separatorBuilder: (context, index) => Container(
            height: 10,
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

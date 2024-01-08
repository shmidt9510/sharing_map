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
  final bool addDeleteButton;
  const ItemsListView(
      {Key? key,
      this.userId = null,
      this.itemFilter = null,
      this.addDeleteButton = false})
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
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, widget.itemFilter ?? 0);
    });
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
  Widget build(BuildContext context) => PagedListView<int, Item>.separated(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        pagingController: _pagingController,
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
              child: Stack(
                children: [
                  ItemBlock(item),
                  widget.addDeleteButton
                      ? Positioned(
                          top: 3,
                          right: 3,
                          child: IconButton(
                              onPressed: () async {
                                await _deleteItemDialogBuilder(
                                    context, item.id ?? "");
                                setState(() {
                                  _pagingController.refresh();
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        )
                      : Container(),
                ],
              )),
        ),
        separatorBuilder: (context, index) => Container(
          height: 10,
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<bool> _deleteItemDialogBuilder(
      BuildContext context, String itemId) async {
    final ItemController _itemsController = Get.find<ItemController>();
    bool _result = false;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы точно хотите удалить объявление?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Да'),
              onPressed: () {
                _itemsController.deleteItem(itemId);
                _result = true;
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Нет'),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
          ],
        );
      },
    );
    return _result;
  }
}

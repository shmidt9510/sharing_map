import 'item_widgets.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/screens/items/item_detail_page.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/widgets/item_block.dart';
import 'package:sharing_map/controllers/item_controller.dart';

class ItemListPage extends StatefulWidget {
  // final String id;
  // const ItemListPage({super.key, required this.id});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  bool isLoading = false;
  ItemController _itemsController = Get.find<ItemController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _itemsController.fetchItems();

    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () {
        return _updateOnFetch();
      },
      child: buildItemListView(_itemsController),
    ));
  }

  Future<void> _updateOnFetch() async {
    await _itemsController.fetchItems();
    setState(() {});
  }
}

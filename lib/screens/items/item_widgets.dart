import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/screens/items/item_detail_page.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/widgets/item_block.dart';
import 'package:sharing_map/controllers/item_controller.dart';

Widget buildItemListView(ItemController _itemsController) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: FutureBuilder<RxList<Item>>(
          future: _itemsController.waitItem(),
          builder:
              (BuildContext context, AsyncSnapshot<RxList<Item>> snapshot) {
            if (snapshot.hasData) {
              return buildItemList(_itemsController);
            } else if (snapshot.hasError) {
              return Placeholder();
            } else {
              return Center(
                child: Row(children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ]),
              );
            }
          }));
}

Widget buildItemList(ItemController _itemsController) {
  return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _itemsController.items.length,
      separatorBuilder: (BuildContext context, int index) => Container(
            height: 20,
          ),
      itemBuilder: (BuildContext context, int index) {
        var item = _itemsController.items[index];
        return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemDetailPage(item)));
            },
            child: ItemBlock(item));
      });
}

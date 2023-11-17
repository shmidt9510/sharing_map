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
      onRefresh: () => _itemsController.fetchItems(),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: FutureBuilder<RxList<Item>>(
              future: _itemsController.waitItem(),
              builder:
                  (BuildContext context, AsyncSnapshot<RxList<Item>> snapshot) {
                if (snapshot.hasData) {
                  return buildItemList();
                } else if (snapshot.hasError) {
                  return Placeholder();
                } else {
                  return Row(children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    ),
                  ]);
                }
              })),
    ));
  }

  Widget buildItemList() {
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

  Widget buildImage() {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: CachedNetworkImage(
            imageUrl:
                "https://hips.hearstapps.com/hmg-prod/images/little-cute-maltipoo-puppy-royalty-free-image-1652926025.jpg"),

        // Ink.image(
        //   image:,
        //   fit: BoxFit.cover,
        //   width: 64,
        //   child: InkWell(onTap: () {
        //     Navigator.of(context).pushReplacement(
        //       CupertinoPageRoute(
        //         builder: (BuildContext context) => ProfilePage(),
        //       ),
        //     );
        //   }),
        // ),
      ),
    );
  }
}

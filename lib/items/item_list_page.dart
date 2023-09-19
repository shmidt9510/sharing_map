import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/items/list_page.dart';
import 'package:sharing_map/items/models/item.dart';
import 'package:sharing_map/items/item_block.dart';
import 'package:sharing_map/items/controllers/item_controller.dart';
import 'package:sharing_map/user/widgets/profile.dart';
import 'package:sharing_map/user/utils/user_preferences.dart';
import 'package:sharing_map/user/page/profile_page.dart';

class ItemListPage extends StatefulWidget {
  // final String id;
  // const ItemListPage({super.key, required this.id});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  late final ItemController _itemsController;
  @override
  void initState() {
    _itemsController = Get.put(ItemController());
    super.initState();
  }

  @override
  void dispose() {
    _itemsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildImage()],
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: TestItemList.length,
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
              }
              // children: items.map<Widget>((item) {
              //   // Material используется для того,
              //   // чтобы указать цвет элементу списка
              //   // и применить ripple эффект при нажатии на него
              //   return
              //   // map возвращает Iterable объект, который необходимо
              //   // преобразовать в список с помощью toList() функции
              // }).toList(),
              )),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(UserPreferences.myUser.imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 64,
          child: InkWell(onTap: () {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (BuildContext context) => ProfilePage(),
              ),
            );
          }),
        ),
      ),
    );
  }
}

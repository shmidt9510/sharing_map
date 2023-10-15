import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/items/list_page.dart';
import 'package:sharing_map/items/models/item.dart';
import 'package:sharing_map/items/item_block.dart';
import 'package:sharing_map/items/controllers/item_controller.dart';
import 'package:sharing_map/user/utils/user_preferences.dart';
import 'package:sharing_map/user/page/profile_page.dart';
import 'package:sharing_map/widgets/image.dart';

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
        appBar: AppBar(
          actions: [buildImage()],
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: FutureBuilder<RxList<Item>>(
                future: _itemsController.waitItem(),
                builder: (BuildContext context,
                    AsyncSnapshot<RxList<Item>> snapshot) {
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
                })));
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
        }
        // children: items.map<Widget>((item) {
        //   // Material используется для того,
        //   // чтобы указать цвет элементу списка
        //   // и применить ripple эффект при нажатии на него
        //   return
        //   // map возвращает Iterable объект, который необходимо
        //   // преобразовать в список с помощью toList() функции
        // }).toList(),
        );
  }

  Widget buildImage() {
    // final image = CachedImage.Get();

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: CachedNetworkImage(
            imageUrl: UserPreferences.myUser.imagePath.toString()),

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

// class _FutureBuilderExampleState extends State<FutureBuilderExample> {
//   final Future<String> _calculation = Future<String>.delayed(
//     const Duration(seconds: 2),
//     () => 'Data Loaded',
//   );

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTextStyle(
//       style: Theme.of(context).textTheme.displayMedium!,
//       textAlign: TextAlign.center,
//       child: FutureBuilder<String>(
//         future: _calculation, // a previously-obtained Future<String> or null
//         builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//           List<Widget> children;
//           if (snapshot.hasData) {
//             children = <Widget>[
//               const Icon(
//                 Icons.check_circle_outline,
//                 color: Colors.green,
//                 size: 60,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 16),
//                 child: Text('Result: ${snapshot.data}'),
//               ),
//             ];
//           } else if (snapshot.hasError) {
//             children = <Widget>[
//               const Icon(
//                 Icons.error_outline,
//                 color: Colors.red,
//                 size: 60,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 16),
//                 child: Text('Error: ${snapshot.error}'),
//               ),
//             ];
//           } else {
//             children = const <Widget>[
//               SizedBox(
//                 width: 60,
//                 height: 60,
//                 child: CircularProgressIndicator(),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 16),
//                 child: Text('Awaiting result...'),
//               ),
//             ];
//           }
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: children,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

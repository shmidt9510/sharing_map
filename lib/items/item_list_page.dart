import 'package:flutter/material.dart';
import 'package:sharing_map/items/list_page.dart';
import 'package:sharing_map/items/item.dart';
import 'package:sharing_map/items/item_block.dart';

class ItemListPage extends StatelessWidget {
  // build как мы уже отметили, строит
  // иерархию наших любимых виджетов
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Page")),
      // зададим небольшие отступы для списка
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          // создаем наш список
          child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              separatorBuilder: (BuildContext context, int index) => Container(
                    height: 20,
                  ),
              itemBuilder: (BuildContext context, int index) {
                var item = items[index];
                return InkWell(
                    onTap: () {
                      // Здесь мы используем сокращенную форму:
                      // Navigator.of(context).push(route)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemDetailPage(item.id)));
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
}

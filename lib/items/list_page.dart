import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:sharing_map/items/item.dart';

List<String> images = [
  "https://extxe.com/wp-content/uploads/2019/04/%D0%BB%D0%B5%D1%81.jpg",
  "https://img.freepik.com/premium-photo/a-forest-with-trees-and-a-path-that-has-the-word-forest-on-it_421632-823.jpg",
  "https://natworld.info/wp-content/uploads/2016/08/Igra-solnechnogo-sveta-v-utrennem-lesu.jpg",
  "https://relax-fm.ru/proxy/vardata/modules/news/files/1/441/news_file_441_5dadd965d5e57.jpg?w=1020&h=680&t=1571674380"
];

class ItemDetailPage extends StatelessWidget {
  final int itemId;

  ItemDetailPage(this.itemId);

  @override
  Widget build(BuildContext context) {
    final item = items[itemId];
    return Scaffold(
        appBar: AppBar(
          title: Text("item Detail Page"),
        ),
        body: ListView(
          // padding: const EdgeInsets.all(8),
          children: [
            GetSlider(images, context),
            Container(
              height: 50,
              color: Colors.amber[600],
              child: const Center(child: Text('Entry A')),
            ),
            Container(
              height: 50,
              color: Colors.amber[500],
              child: const Center(child: Text('Entry B')),
            ),
            Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry C')),
            ),
          ],
        ));
  }
}

Widget GetSlider(images1, context) {
  return CarouselSlider(
    options: CarouselOptions(
      height: MediaQuery.of(context).size.height / 3,
      // height: 300.0,
      viewportFraction: 1.0,
      enlargeCenterPage: false,
      onPageChanged: (position, reason) {
        print(reason);
        print(CarouselPageChangedReason.controller);
      },
      enableInfiniteScroll: false,
    ),
    items: images1.map<Widget>((image) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
              width: MediaQuery.of(context).size.width,
              // height: 100,
              // width: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.fitHeight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
                // цвет Container'а мы указываем в BoxDecoration
                color: Colors.white,
              ));
        },
      );
    }).toList(),
  );
}

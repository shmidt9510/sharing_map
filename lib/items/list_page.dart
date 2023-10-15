import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:sharing_map/items/models/item.dart';
import 'package:sharing_map/items/models/photo.dart';
import 'package:sharing_map/widgets/image.dart';

List<String> imagesMock = [
  "https://extxe.com/wp-content/uploads/2019/04/%D0%BB%D0%B5%D1%81.jpg",
  "https://img.freepik.com/premium-photo/a-forest-with-trees-and-a-path-that-has-the-word-forest-on-it_421632-823.jpg",
  "https://natworld.info/wp-content/uploads/2016/08/Igra-solnechnogo-sveta-v-utrennem-lesu.jpg",
  "https://relax-fm.ru/proxy/vardata/modules/news/files/1/441/news_file_441_5dadd965d5e57.jpg?w=1020&h=680&t=1571674380"
];

class ItemDetailPage extends StatelessWidget {
  final Item item;

  ItemDetailPage(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("item Detail Page"),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              // Add your onPressed code here!
            },
            label: const Text('Связаться'),
            icon: const Icon(Icons.messenger_outline_outlined),
            backgroundColor: Colors.green,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: ListView(
          // padding: const EdgeInsets.all(8),
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GetSlider(item.images, context),
              ),
            ),
            Container(
                height: 50,
                child: Text(item.creationDate.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic))),
            Container(
                height: 50,
                child: Text(item.name ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(
                child: Text(item.desc ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal))),
          ],
        ));
  }
}

Widget GetSlider(images, context) {
  List<Widget> list = [];
  for (var i = 0; i < images.length; i++) {
    list.add(CachedImage.Get(images[i]));
  }
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
    items: list.map<Widget>((image) {
      return Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            child: Hero(
              tag: 'carusel_image_list',
              child: Container(
                  child: image,
                  width: MediaQuery.of(context).size.width,
                  // height: 100,
                  // width: 500,
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    // image: Cached(image), fit: BoxFit.fitHeight),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                    // цвет Container'а мы указываем в BoxDecoration
                    color: Colors.white,
                  )),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return GetFullscreenSlider(image, context);
              }));
            },
          );
        },
      );
    }).toList(),
  );
}

Widget GetFullscreenSlider(image, context) {
  final double height = MediaQuery.of(context).size.height;
  return Scaffold(
    appBar: AppBar(
      title: Text("item Detail Page"),
    ),
    body: Center(
      child: GestureDetector(
        child: Hero(tag: 'carusel_image_list', child: image),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}

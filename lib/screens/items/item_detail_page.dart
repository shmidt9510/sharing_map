import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/widgets/image.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;

  ItemDetailPage(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 10.0),
        //   child: FloatingActionButton.extended(
        //     onPressed: () {
        //       // Add your onPressed code here!
        //     },
        //     label: const Text('Связаться'),
        //     icon: const Icon(Icons.messenger_outline_outlined),
        //     backgroundColor: Colors.green,
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              child: GetSlider(item.images, context),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                      child: Text("",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic))),
                  Spacer(),
                  Container(
                      height: 50,
                      child: Text(
                          DateFormat('dd.MM.yyyy')
                              .format(item.creationDate ?? DateTime.now()),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic))),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    item.name ?? "",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(item.desc ?? "",
                    style: TextStyle(fontWeight: FontWeight.normal))),
            Container(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(item.adress ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal))),
            // Container(child: Image(image: ))
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

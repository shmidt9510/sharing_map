import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';

import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/user/page/user_profile_page.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/image.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailPage extends StatelessWidget {
  final Item item;
  final UserController _userController = Get.find<UserController>();
  final CommonController _commonController = Get.find<CommonController>();

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
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
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
                padding: EdgeInsets.symmetric(horizontal: 23),
                child: Text(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    item.name ?? "",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 23),
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
            GetLocationsWidget(context, item, _commonController),
            Container(
              height: 20,
            ),
            GetUserWidget(context, item),
          ],
        ));
  }
}

Widget GetLocationsWidget(
    BuildContext context, Item item, CommonController controller) {
  if (item.locationIds == null) {
    return Container(
      height: 40,
    );
  }
  var locationsMap = controller.locationsMap;
  List<SMLocation> locations = [];

  item.locationIds?.forEach((locId) {
    if (locationsMap.containsKey(locId)) {
      locations.add(locationsMap[locId]!);
    }
  });
  return Container(
    padding: EdgeInsets.only(left: 23),
    height: 25.0 * locations.length,
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: locations.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            height: 25,
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Row(
                children: [
                  Icon(
                    Icons.subway_outlined,
                    size: 14,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      locations[index].name,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ));
      },
    ),
  );
}

Widget GetSlider(images, context) {
  int _count = 0;
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
      enableInfiniteScroll: false,
    ),
    items: list.map<Widget>((image) {
      var result = Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            child: Hero(
              tag: 'carusel_image_list$_count',
              child: Container(
                  child: image,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                    color: Colors.white,
                  )),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return GetFullscreenSlider(image, context, _count);
              }));
            },
          );
        },
      );
      _count++;
      return result;
    }).toList(),
  );
}

Widget GetFullscreenSlider(image, context, count) {
  return Scaffold(
    appBar: AppBar(),
    body: Center(
      child: GestureDetector(
        child: Hero(tag: 'carusel_image_list$count', child: image),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}

Widget GetUserWidget(BuildContext context, Item item) {
  final UserController _userController = Get.find<UserController>();
  bool _isLogged = SharedPrefs().logged;
  return SizedBox(
    height: 100,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: MColors.darkGreen, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _userController.GetUser(item.userId ?? ""),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container();
                  }

                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                  var _user = snapshot.data as User;
                  return Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: InkWell(
                        onTap: () {
                          // GoRouter.of(context).goNamed("/user",
                          //     pathParameters: {'userId': _user.id});
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserProfilePage(userId: _user.id)));
                        },
                        child: ClipOval(
                          child: Container(
                            width: 45,
                            height: 45,
                            child: _user.buildImage(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        _user.username,
                        maxLines: 2,
                      ),
                    ),
                  ]);
                },
              ),
            ),
            Expanded(
              child: _isLogged
                  ? FutureBuilder(
                      future: _userController.getUserContact(item.userId ?? ""),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Container();
                        }
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator.adaptive());
                        }
                        return GetUserContactWidget(
                            snapshot.data as List<UserContact>);
                      })
                  : Container(),
            )
          ],
        ),
      ),
    ),
  );
}

Widget GetUserContactWidget(List<UserContact> contacts) {
  String _contactText = "";
  int _priority = 0;
  for (final contact in contacts) {
    if (contact.type == UserContactType.TELEGRAM && _priority >= 0) {
      _contactText = contact.contact;
      _priority = 2;
    }
    if (contact.type == UserContactType.WHATSAPP && _priority < 2) {
      _contactText = contact.contact;
      _priority = 1;
    }
    if (contact.type == UserContactType.PHONE && _priority < 1) {
      _contactText = contact.contact;
    }
  }

  return Row(
    children: [
      ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) => GetContactTypeWidget(
          contacts[index],
        ),
      ),
      SelectableText(
        _contactText,
        style: TextStyle(fontStyle: FontStyle.normal),
      ),
    ],
  );
}

Widget GetContactTypeWidget(UserContact contact) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: IconButton(
      icon: Icon(contact.contactIcon),
      onPressed: () async {
        final url = Uri.parse(contact.getUri + contact.contact);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          print('Unable to launch $url');
        }
      },
    ),
  );
}

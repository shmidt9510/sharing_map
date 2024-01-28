import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';

import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/user/page/user_profile_page.dart';
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
        body: ListView(
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
                padding: const EdgeInsets.only(
                    left: 23.0, top: 20, bottom: 0, right: 23),
                child: GetUserWidget(context, item)),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
                child: Text(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    item.name ?? "",
                    style: getBigTextStyle())),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 23),
                child: Text(
                  item.desc ?? "",
                  style: getMediumTextStyle(),
                )),
            SizedBox(
              height: 10,
            ),
            GetLocationsWidget(context, item, _commonController),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23),
              child: Text(
                DateFormat('dd.MM.yyyy')
                    .format(item.creationDate ?? DateTime.now()),
                style: getHintTextStyle(),
              ),
            )
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
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Center(
                  child: SvgPicture.asset(
                'assets/icons/subway_moscow.svg',
                height: 18,
                width: 18,
              )),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  locations[index].name,
                  style: getHintTextStyle(),
                ),
              ),
            ],
          ),
        );
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
      height: MediaQuery.of(context).size.height / 2.5,
      // height: cona,
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
  return Container(
    child: Row(
      children: [
        FutureBuilder(
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
              InkWell(
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
                    child: _user.buildImage(fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  _user.username,
                  style: getHintTextStyle(),
                  // maxLines: 2,
                ),
              ),
            ]);
          },
        ),
        Spacer(),
        SizedBox(
          height: 50,
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
  );
}

Widget GetUserContactWidget(List<UserContact> contacts) {
  return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        return contacts[index].contact.isNotEmpty
            ? GetContactTypeWidget(contacts[index])
            : Container();
      });
}

Widget GetContactTypeWidget(UserContact contact) {
  bool showContact = contact.contact.isNotEmpty;
  return showContact
      ? IconButton(
          icon: Icon(contact.contactIcon),
          onPressed: () async {
            final url = Uri.parse(contact.getUri + contact.contact);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              print('Unable to launch $url');
            }
          },
        )
      : Container();
}

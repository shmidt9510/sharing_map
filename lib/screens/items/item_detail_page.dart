import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';

import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/contact_type_widget.dart';
import 'package:sharing_map/widgets/image.dart';

class ItemDetailPage extends StatefulWidget {
  final String itemId;

  ItemDetailPage(this.itemId);

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final ItemController _itemController = Get.find<ItemController>();

  final CommonController _commonController = Get.find<CommonController>();

  int _currentPicture = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: _itemController.GetItem(widget.itemId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              Item item = snapshot.data as Item;
              return ListView(
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
                    child: GetSlider(item.images, context, (int index) {
                      setState(() {
                        _currentPicture = index;
                      });
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: item.images!.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? MColors.grey1
                                    : MColors.darkGreen)
                                .withOpacity(
                                    _currentPicture == entry.key ? 0.9 : 0.4)),
                      );
                    }).toList(),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 23.0, top: 20, bottom: 0, right: 23),
                      child: GetUserWidget(context, item)),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 23, vertical: 10),
                      child: Text(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          item.name,
                          style: getBigTextStyle())),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 23),
                      child: Text(
                        item.desc,
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
                          .format(item.updateDate ?? DateTime.now()),
                      style: getHintTextStyle(),
                    ),
                  )
                ],
              );
            }));
  }

  Widget GetSlider(images, context, void Function(int) callback) {
    int _count = 0;
    List<Widget> list = [];
    for (var i = 0; i < images.length; i++) {
      list.add(CachedImage.Get(images[i]));
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height / 2.5,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          callback(index);
        },
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
                child: locations[index].getLocationIcon,
              ),
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

Widget GetFullscreenSlider(image, context, count) {
  return Scaffold(
    appBar: AppBar(),
    body: Center(
      child: GestureDetector(
        child: Hero(
            tag: 'carusel_image_list$count',
            child: InteractiveViewer(
              child: image,
            )),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}

Widget GetUserWidget(BuildContext context, Item item) {
  final UserController _userController = Get.find<UserController>();

  return Container(
    child: Row(
      children: [
        FutureBuilder(
          future: _userController.GetUser(item.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (!snapshot.hasData) {
              return Container(color: MColors.green);
            }
            var _user = snapshot.data as User;
            return Row(children: [
              InkWell(
                onTap: () {
                  GoRouter.of(context).go(SMPath.home + "/user/${_user.id}");
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             UserProfilePage(userId: _user.id)));
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
        SizedBox(height: 50, child: GetUserContactWidget(context, item.userId))
      ],
    ),
  );
}

Widget GetUserContactWidget(BuildContext context, String userId) {
  final UserController _userController = Get.find<UserController>();
  return SharedPrefs().logged
      ? FutureBuilder(
          future: _userController.getUserContact(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            }
            if (!snapshot.hasData) {
              return Container();
            }
            var contacts = snapshot.data as List<UserContact>;
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  return contacts[index].contact.isNotEmpty
                      ? ContactTypeButton(contacts[index])
                      : Container();
                });
          })
      : GetGoRegisterButton(context);
}

Widget GetGoRegisterButton(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      textStyle: getSmallTextStyle(),
      backgroundColor: MColors.secondaryGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: () {
      SnackBar snackBar = SnackBar(
        content: Text("Нужно зарегистрироваться для просмотра контактов"),
        action: SnackBarAction(
          label: 'Перейти',
          onPressed: () async {
            GoRouter.of(context).go(SMPath.start + "/" + SMPath.registration);
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    },
    child: Icon(Icons.phone),
  );
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/city.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

class TopIcons extends StatefulWidget {
  @override
  _TopIconsState createState() => _TopIconsState();
}

class _TopIconsState extends State<TopIcons> {
  var _userController = Get.find<UserController>();
  var _commonController = Get.find<CommonController>();
  var _itemsController = Get.find<ItemController>();

  late City dropdownValue;

  @override
  void initState() {
    super.initState();

    if (SharedPrefs().chosenCity == -1) {
      dropdownValue = _commonController.cities.first;
    } else {
      var _cities = _commonController.cities;
      dropdownValue = _cities
          .firstWhere((element) => element.id == SharedPrefs().chosenCity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(flex: 14),
        Expanded(
            flex: 2,
            child: IconButton(
              style: IconButton.styleFrom(
                shape: CircleBorder(),
                side: BorderSide(width: 2, color: MColors.darkGreen),
                padding: EdgeInsets.all(0), // Remove default padding
              ),
              padding: EdgeInsets.all(0),
              icon: Icon(
                size: 14,
                FontAwesomeIcons.info,
                color: MColors.darkGreen,
              ),
              onPressed: () async {
                await _showInfoMessage(context);
              },
            )),
        Expanded(
            flex: 2,
            child: IconButton(
              style: IconButton.styleFrom(
                shape: CircleBorder(),
                side: BorderSide(width: 2, color: MColors.darkGreen),
                padding: EdgeInsets.all(0), // Remove default padding
              ),
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.location_on_rounded,
                color: MColors.darkGreen,
                size: 18,
              ),
              onPressed: () async {
                await _chooseCityDialog(context);
              },
            )),
        Expanded(
          flex: 2,
          child: OutlinedButton(
            onPressed: () {
              GoRouter.of(context).go(SMPath.myItems + "/" + SMPath.profile);
            },
            style: OutlinedButton.styleFrom(
              shape: CircleBorder(),
              side: BorderSide(width: 2, color: MColors.darkGreen),
              padding: EdgeInsets.all(0), // Remove default padding
            ),
            child: ClipOval(
              child: Container(
                  width: 25, // Width of the circular button
                  height: 25, // Height of the circular button
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: _userController.userProfilePicture.value
                  // Image.asset(
                  //   imagePath,
                  //   fit: BoxFit.cover, // Ensure the image fits the circle
                  // ),
                  ),
            ),
          ),
        ),
        Spacer(flex: 1)
      ],
    );
  }

  Future<bool> _chooseCityDialog(BuildContext context) async {
    bool _result = false;
    var _cities = _commonController.cities;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Column(
              children: [
                Text("Выберите город",
                    style: getBigTextStyle()
                        .copyWith(color: MColors.black, fontSize: 20)),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: MColors.white),
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: DropdownButton<City>(
                        icon: Icon(
                          FontAwesomeIcons.caretDown,
                          color: MColors.darkGreen,
                        ),
                        underline: Container(),
                        dropdownColor: MColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        value: dropdownValue,
                        onChanged: (City? newValue) {
                          setState(() {
                            dropdownValue =
                                newValue ?? City(-1, "Выберите город", null);
                          });
                        },
                        items:
                            _cities.map<DropdownMenuItem<City>>((City value) {
                          return DropdownMenuItem<City>(
                            value: value,
                            child: Container(
                                color: MColors.white,
                                child: Text(
                                  value.name,
                                  style: getMediumTextStyle()
                                      .copyWith(color: MColors.black),
                                )),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              LoadingButton("Выбрать", () async {
                SharedPrefs().chosenCity = dropdownValue.id;
                await _commonController.getLocations(SharedPrefs().chosenCity);
                _itemsController.refershAll();
                Navigator.of(context).maybePop();
              },
                  textStyle: getBigTextStyle()
                      .copyWith(color: MColors.white, fontSize: 20)),
            ],
          );
        });
      },
    );
    return _result;
  }

  Future<void> _showInfoMessage(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: 240,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        style: getMediumTextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                'Если вы хотите связаться с командой приложения, напишите нам. Будем рады обратной связи!',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        await canLaunchUrl(Uri.parse("https://t.me/wwwuzik"));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.telegram),
                          SizedBox(
                            width: 5,
                          ),
                          Text("telegram")
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(
                          width: 5,
                        ),
                        SelectableText("info@sharingmap.ru")
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

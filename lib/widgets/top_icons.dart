import 'dart:async';

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
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/item_type_widget.dart';
import 'package:sharing_map/widgets/loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

class TopIcons extends StatefulWidget {
  @override
  _TopIconsState createState() => _TopIconsState();

  final Function(int) onItemTypeChange;
  final ValueChanged<String> onSearchChanged;

  TopIcons({required this.onItemTypeChange, required this.onSearchChanged});
}

class _TopIconsState extends State<TopIcons> {
  var _userController = Get.find<UserController>();
  var _commonController = Get.find<CommonController>();
  var _itemsController = Get.find<ItemController>();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  late City dropdownValue;

  Widget BuildButton(Widget icon, VoidCallback? onPressed) {
    return Padding(
      padding: EdgeInsets.only(left: 3, right: 3),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: CircleBorder(),
          side: BorderSide(width: 2, color: MColors.darkGreen),
          padding: EdgeInsets.all(0),
        ),
        child: ClipOval(
          child: Container(
              width: 25, // Width of the circular button
              height: 25, // Height of the circular button
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: icon),
        ),
      ),
    );
  }

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
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ItemTypeList(onItemTypeChange: widget.onItemTypeChange),
            flex: 2,
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: _buildSearchField(),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
              flex: 1,
              child: BuildButton(
                  Icon(
                    FontAwesomeIcons.info,
                    color: MColors.darkGreen,
                    size: 14,
                  ), () async {
                await _showInfoMessage(context);
              })),
          Expanded(
              flex: 1,
              child: BuildButton(
                  Icon(
                    Icons.location_on_rounded,
                    color: MColors.darkGreen,
                    size: 14,
                  ), () async {
                await _chooseCityDialog(context);
              })),
          Expanded(
            flex: 1,
            child: BuildButton(
                Obx(() => (_userController.userProfilePicture.value)), () {
              GoRouter.of(context).go(SMPath.myItems + "/" + SMPath.profile);
            }),
          ),
          SizedBox(width: 4)
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        border: Border.all(
          color: MColors.lightGrey,
          width: 1,
        ),
        color: MColors.inputField,
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        maxLines: 1,
        minLines: 1,
        textAlignVertical: TextAlignVertical.center,
        strutStyle: const StrutStyle(
          forceStrutHeight: true,
          height: 1.2,
        ),
        style: getMediumTextStyle().copyWith(height: 1.2),
        cursorHeight: 20,
        decoration: InputDecoration(
          isDense: true,
          hintText: "Поиск",
          hintStyle: getHintTextStyle(),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: InputBorder.none,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 40, minHeight: 40),
          prefixIcon: Icon(
            Icons.search,
            color: MColors.darkGreen,
            size: 16,
          ),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 40, minHeight: 40),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.close,
                    color: MColors.darkGreen,
                    size: 16,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearchChanged("");
                    setState(() {});
                  },
                ),
        ),
        onChanged: (value) {
          _searchDebounce?.cancel();
          setState(() {});
          _searchDebounce = Timer(Duration(milliseconds: 350), () {
            widget.onSearchChanged(value);
          });
        },
        onSubmitted: (value) {
          _searchDebounce?.cancel();
          widget.onSearchChanged(value);
        },
      ),
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
                try {
                  await _commonController.getLocations(dropdownValue.id, true);
                } catch (e) {
                  showErrorScaffold(context, "Не получилось");
                }
                SharedPrefs().chosenCity = dropdownValue.id;
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Если вы хотите связаться с командой приложения, напишите нам. Будем рады обратной связи!',
                    style: getMediumTextStyle(),
                    textAlign: TextAlign.start,
                    maxLines: 4,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse("https://t.me/wuzik"))) {
                        await launchUrl(Uri.parse("https://t.me/wuzik"));
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.telegram),
                        SizedBox(
                          width: 5,
                        ),
                        Text("@wuzik", style: getMediumTextStyle())
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
                      SelectableText(
                        "info@sharingmap.ru",
                        style: getMediumTextStyle(),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Ещё у нас есть канал',
                      // textAlign: TextAlign.start,
                      style: getMediumTextStyle()),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      if (await canLaunchUrl(
                          Uri.parse("https://t.me/sharingmap"))) {
                        await launchUrl(Uri.parse("https://t.me/sharingmap"));
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.telegram),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "@sharingmap",
                          style: getMediumTextStyle(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

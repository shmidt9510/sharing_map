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
import 'package:sharing_map/widgets/loading_button.dart';

class UserActionsWidget extends StatefulWidget {
  @override
  _UserActionsWidgetState createState() => _UserActionsWidgetState();
}

enum MenuItem { chooseCity, logout, deleteUser }

class _UserActionsWidgetState extends State<UserActionsWidget> {
  UserController _userController = Get.find<UserController>();
  CommonController _commonController = Get.find<CommonController>();
  ItemController _itemsController = Get.find<ItemController>();

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

  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      icon: Icon(
        Icons.settings,
        color: MColors.darkGreen,
      ),
      // initialValue: selectedItem,
      onSelected: (MenuItem item) {
        switch (item) {
          case MenuItem.chooseCity:
            {
              _chooseCityDialog(context);
            }
            break;
          case MenuItem.deleteUser:
            {
              _deleteDialogBuilder(context);
            }
            break;
          case MenuItem.logout:
            {
              _logoutDialog(context);
            }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
        PopupMenuItem<MenuItem>(
          value: MenuItem.chooseCity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_city, color: MColors.darkGreen),
              SizedBox(width: 10),
              Text(
                "Выбрать город",
                style: getSmallTextStyle(),
              ),
            ],
          ),
        ),
        PopupMenuItem<MenuItem>(
          value: MenuItem.logout,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.logout, color: MColors.red1),
              SizedBox(width: 10),
              Text(
                "Выйти из аккаунта",
                style: getSmallTextStyle(),
              ),
            ],
          ),
        ),
        PopupMenuItem<MenuItem>(
            value: MenuItem.deleteUser,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.delete, color: MColors.red1),
                SizedBox(width: 10),
                Text(
                  "Удалить пользователя",
                  style: getSmallTextStyle(),
                ),
              ],
            )),
      ],
    );
  }

  Future<bool> _deleteDialogBuilder(BuildContext context) async {
    bool _result = false;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы точно хотите удалить свой аккаунт?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Да'),
              onPressed: () {
                _result = true;
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Нет'),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
          ],
        );
      },
    );
    if (_result) {
      if (await _userController.DeleteMyself()) {
        final ItemController _itemsController = Get.put(ItemController());
        _itemsController.userPagingController.refresh();
        _itemsController.userPagingController
            .removePageRequestListener((pageKey) {});
        showSnackBar(context, 'До скорых встреч');
        GoRouter.of(context).go(SMPath.start);
      }
    }
    return _result;
  }

  Future<bool> _logoutDialog(BuildContext context) async {
    bool _result = false;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Разлогиниться'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Да'),
              onPressed: () {
                _result = true;
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Нет'),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
          ],
        );
      },
    );
    if (_result) {
      if (await _userController.Logout()) {
        final ItemController _itemsController = Get.put(ItemController());
        _itemsController.userPagingController.refresh();
        _itemsController.userPagingController
            .removePageRequestListener((pageKey) {});
        showSnackBar(context, 'До скорых встреч');
        setState(() {});
        GoRouter.of(context).go(SMPath.start);
      }
    }
    return _result;
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
}

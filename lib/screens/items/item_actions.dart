import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/city.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/loading_button.dart';

class ItemActionsWidget extends StatefulWidget {
  final Item _item;

  ItemActionsWidget(this._item);

  @override
  _ItemActionsWidgetState createState() => _ItemActionsWidgetState();
}

enum MenuItem { editItem, deleteItem }

class _ItemActionsWidgetState extends State<ItemActionsWidget> {
  ItemController _itemsController = Get.find<ItemController>();
  CommonController _commonController = Get.find<CommonController>();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      icon: Icon(
        Icons.menu,
        color: MColors.darkGreen,
      ),
      // initialValue: selectedItem,
      onSelected: (MenuItem item) {
        switch (item) {
          case MenuItem.editItem:
            {
              _editItem(context);
            }
            break;
          case MenuItem.deleteItem:
            {
              _deleteItem(context);
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
        PopupMenuItem<MenuItem>(
          value: MenuItem.editItem,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.edit, color: MColors.darkGreen),
              SizedBox(width: 10),
              Text(
                "Редактировать",
                style: getSmallTextStyle(),
              ),
            ],
          ),
        ),
        PopupMenuItem<MenuItem>(
            value: MenuItem.deleteItem,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.delete, color: MColors.red1),
                SizedBox(width: 10),
                Text(
                  "Удалить",
                  style: getSmallTextStyle(),
                ),
              ],
            )),
      ],
    );
  }

  Future<bool> _editItem(BuildContext context) async {
    if (widget._item.cityId != SharedPrefs().chosenCity) {
      var _chosenCity = _commonController.cities
          .firstWhere((element) => element.id == widget._item.cityId);
      showErrorScaffold(context,
          "Чтобы менять объявления в городе ${_chosenCity.name}, пожалуйста переключитесь на него");
    } else {
      GoRouter.of(context).go(SMPath.home + "/itemEdit/${widget._item.id}");
    }
    return true;
  }

  Future<bool> _deleteItem(BuildContext context) async {
    await _deleteItemDialogBuilder(context, widget._item.id);
    _itemsController.userPagingController.refresh();
    return true;
  }

  Future<bool> _deleteItemDialogBuilder(
      BuildContext context, String itemId) async {
    final ItemController _itemsController = Get.find<ItemController>();
    bool _result = false;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы точно хотите удалить объявление?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Да'),
              onPressed: () {
                _itemsController.deleteItem(itemId);
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
    return _result;
  }
}

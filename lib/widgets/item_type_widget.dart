import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';

class ItemTypeList extends StatefulWidget {
  @override
  _ItemTypeListState createState() => _ItemTypeListState();

  final Function(int) onItemTypeChange;
  ItemTypeList({required this.onItemTypeChange});
}

class _ItemTypeListState extends State<ItemTypeList> {
  final List<String> _items = ['Отдаю', 'Возьму'];
  String _selectedItem = 'Отдаю';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(
            color: MColors.lightGrey, // Border color
            width: 1, // Border width
          ),
        ),
        child: DropdownButton<String>(
          value: _selectedItem,
          underline: Container(),
          dropdownColor: MColors.inputField,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          onChanged: (String? newValue) {
            setState(() {
              _selectedItem = newValue ?? 'Отдаю';
            });
            int _type = 1;
            if (newValue == 'Возьму') {
              _type = 2;
            }
            widget.onItemTypeChange(_type);
          },
          icon: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              size: (context.height * .02),
              FontAwesomeIcons.chevronDown,
              color: MColors.darkGreen,
            ),
          ),
          isExpanded: true,
          items: _items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(value, style: getMediumTextStyle()),
              ),
              alignment: Alignment.centerLeft,
            );
          }).toList(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/image.dart';

class TextDescriptionBlock extends StatelessWidget {
  Item _item;
  TextDescriptionBlock(this._item);
  @override
  Widget build(BuildContext context) {
    var _commonController = Get.find<CommonController>();
    String _location = "";
    int _locationCount = 0;
    if (_item.locationIds != null &&
        _item.locationIds!.length > 0 &&
        _commonController.locationsMap.containsKey(_item.locationIds![0])) {
      _locationCount = _item.locationIds!.length;
      _location = _commonController.locationsMap[_item.locationIds![0]]!.name;
    }
    _locationCount -= 1;
    String itemName = _item.name.toLowerCase();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.topLeft,
            constraints: BoxConstraints(maxWidth: context.width * 3 / 5),
            child: Text(
              "${itemName[0].toUpperCase()}${itemName.substring(1)}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getBigTextStyle(),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: context.width * 0.4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: SvgPicture.asset(
                    'assets/icons/subway_moscow.svg',
                    height: 18,
                    width: 18,
                  )),
                  Flexible(
                    child: Text(
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      _location,
                      style: getHintTextStyle(),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  _locationCount > 0
                      ? CircleAvatar(
                          maxRadius: 18 * 0.7,
                          backgroundColor: MColors.lightGreen,
                          foregroundColor: MColors.lightGreen,
                          child: Text(
                            "+$_locationCount",
                            style: getHintTextStyle()
                                .copyWith(color: MColors.black),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat('dd.MM.yy')
                    .format(_item.creationDate ?? DateTime.now()),
                style: getHintTextStyle(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            )),
      ],
    );
  }
}

class ItemBlock extends StatelessWidget {
  final Item _item;

  ItemBlock(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height / 5,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
              flex: 2,
              child: Container(
                width: context.height / 6,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: _item.images!.length > 0
                            ? Container(
                                child: CachedImage.Get(_item.images![0]))
                            : Placeholder(
                                color: MColors.black,
                              ))),
              )),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextDescriptionBlock(_item),
            ),
          )
        ],
      ),
    );
  }
}

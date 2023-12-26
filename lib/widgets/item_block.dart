import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/image.dart';

class TextDescriptionBlock extends StatelessWidget {
  Item _item;
  TextDescriptionBlock(this._item);
  @override
  Widget build(BuildContext context) {
    var _commonController = Get.find<CommonController>();
    String _location = "";
    if (_item.locationIds != null &&
        _item.locationIds!.length > 0 &&
        _commonController.locationsMap.containsKey(_item.locationIds![0])) {
      _location = _commonController.locationsMap[_item.locationIds![0]]!.name;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            constraints: BoxConstraints(maxWidth: context.width * 3 / 5),
            child: Text(
              _item.name ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.0,
                fontFamily: 'Roboto',
                color: Color(0xFF212121),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
            child: Text(
          overflow: TextOverflow.ellipsis,
          _item.desc ?? "",
          maxLines: 1,
          textAlign: TextAlign.start,
        )),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.subway_outlined,
                      size: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        _location,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Text(_item.name,
        //               style: Theme.of(context)
        //                   .textTheme
        //                   .headlineMedium
        //                   ?.copyWith(color: Colors.black))
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
      height: 100,
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
                width: 100,
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
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: TextDescriptionBlock(_item),
            ),
          )
        ],
      ),
    );
  }
}

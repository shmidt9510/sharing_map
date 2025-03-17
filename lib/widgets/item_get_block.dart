import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/size_controller.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/image.dart';
import 'package:intl/date_symbol_data_local.dart';

class TextDescriptionGetBlock extends StatelessWidget {
  final Item _item;
  TextDescriptionGetBlock(this._item);
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    String itemName = _item.name;
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
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Flexible(flex: 1, child: Icon(FontAwesomeIcons.userAstronaut)),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    _item.username ?? "NoUserName",
                    style: getMediumTextStyle(),
                  ),
                ),
              ]),
            ),
          ),
        ),
        // SizedBox(
        //   height: 4,
        // ),
        // Expanded(
        //     flex: 1,
        //     child: Container(
        //       alignment: Alignment.centerLeft,
        //       child: Text(
        //         DateFormat('d MMMM', 'ru')
        //             .format(_item.updateDate ?? DateTime.now()),
        //         style: getHintTextStyle(),
        //         overflow: TextOverflow.ellipsis,
        //         maxLines: 1,
        //       ),
        //     )),
      ],
    );
  }
}

class ItemGetBlock extends StatelessWidget {
  final Item _item;
  final SizeController _sizeController = Get.find<SizeController>();
  ItemGetBlock(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _sizeController.GetHeightOfItems(),
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
              child: TextDescriptionGetBlock(_item),
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}

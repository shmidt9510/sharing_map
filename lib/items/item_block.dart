import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/items/item.dart';

class TextDescriptionBlock extends StatelessWidget {
  Item _item;
  TextDescriptionBlock(this._item);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            constraints: BoxConstraints(maxWidth: context.width * 3 / 5),
            child: Text(
              _item.desc,
              maxLines: 3,
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
        Flexible(
            child: Text(
          "_item.name",
          textAlign: TextAlign.start,
        )),
        Flexible(
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
                        _item.name,
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
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // цвет Container'а мы указываем в BoxDecoration
        color: Colors.white,
      ),
      // color: Colors.green,
      // InkWell позволяет отслеживать
      // различные события, например: нажатие
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                child: Image.asset(_item.picture, fit: BoxFit.fitHeight)),
          ),
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

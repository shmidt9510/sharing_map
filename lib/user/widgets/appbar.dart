import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar buildAppBar(BuildContext context) {
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    leading: BackButton(
      color: Colors.green,
      onPressed: () => Navigator.of(context).pop(),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(
          Icons.edit,
          color: context.theme.secondaryHeaderColor,
        ),
        onPressed: () {},
      ),
    ],
  );
}

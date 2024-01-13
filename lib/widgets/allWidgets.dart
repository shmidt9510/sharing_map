import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:sharing_map/model/data/Products.dart';
// import 'package:sharing_map/model/notifiers/cart_notifier.dart';
// import 'package:sharing_map/model/services/Product_service.dart';
// import '../../deprecated/tab_screens/homeScreen_pages/productDetailsScreen.dart';
import 'package:sharing_map/utils/colors.dart';

Widget secondaryButtonGreen(
  Widget buttonChild,
  void Function()? onPressed,
) {
  return SizedBox(
    width: double.infinity,
    height: 50.0,
    child: RawMaterialButton(
      elevation: 0.0,
      hoverElevation: 0.0,
      focusElevation: 0.0,
      highlightElevation: 0.0,
      fillColor: MColors.secondaryGreen,
      child: buttonChild,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
    ),
  );
}

Widget secondaryButtonGreenSmoke(
  Widget buttonChild,
  void Function() onPressed,
) {
  return SizedBox(
    width: double.infinity,
    height: 50.0,
    child: RawMaterialButton(
      elevation: 0.0,
      hoverElevation: 0.0,
      focusElevation: 0.0,
      highlightElevation: 0.0,
      fillColor: MColors.white,
      child: buttonChild,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:sharing_map/utils/colors.dart';

ThemeData GetAppTheme() {
  return ThemeData(
      iconTheme: IconThemeData(color: MColors.secondaryGreen),
      // iconButtonTheme: IconButtonThemeData(
      //     style: ButtonStyle(iconColor: MColors.secondaryGreen)),
      appBarTheme: AppBarTheme(
        backgroundColor: MColors.secondaryGreen,
        surfaceTintColor: MColors.primaryGreen.withOpacity(1),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      hintColor: Colors.brown,
      splashColor: Colors.yellow,
      scaffoldBackgroundColor: MColors.primaryWhite,
      secondaryHeaderColor: MColors.primaryGreen.withOpacity(1),
      textTheme: TextTheme(headlineLarge: TextStyle(color: MColors.whiteText)),
      primaryColor: MColors.secondaryGreen);
}

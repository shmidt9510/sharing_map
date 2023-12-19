import 'package:flutter/material.dart';
import 'package:sharing_map/utils/colors.dart';

ThemeData GetAppTheme() {
  return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: MColors.darkGreen,
      ),
      iconTheme: IconThemeData(color: MColors.secondaryGreen),
      // iconButtonTheme: IconButtonThemeData(
      //     style: ButtonStyle(iconColor: MColors.secondaryGreen)),
      appBarTheme: AppBarTheme(
        backgroundColor: MColors.secondaryGreen,
        surfaceTintColor: MColors.primaryGreen.withOpacity(1),
        actionsIconTheme: const IconThemeData(color: MColors.white),
      ),
      unselectedWidgetColor: MColors.black,
      primaryIconTheme: IconThemeData(color: MColors.darkGreen),
      buttonTheme: ButtonThemeData(buttonColor: MColors.darkGreen),
      hintColor: MColors.black,
      splashColor: MColors.lightGreen,
      scaffoldBackgroundColor: Colors.white,
      secondaryHeaderColor: MColors.primaryGreen.withOpacity(1),
      textTheme: TextTheme(headlineLarge: TextStyle(color: Colors.blue)),
      primaryColor: MColors.secondaryGreen);
}

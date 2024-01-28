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
      textTheme: TextTheme(
          displayLarge: TextStyle(
              color: Colors.black, fontFamily: 'Roboto', letterSpacing: -0.41),
          displayMedium: TextStyle(
              color: Colors.black, fontFamily: 'Roboto', letterSpacing: -0.41),
          displaySmall: TextStyle(
              color: Colors.black, fontFamily: 'Roboto', letterSpacing: -0.41),
          headlineMedium: TextStyle(
              color: Colors.black, fontFamily: 'Roboto', letterSpacing: -0.41),
          headlineSmall: TextStyle(
              color: Colors.black, fontFamily: 'Roboto', letterSpacing: -0.41),
          titleLarge: TextStyle(
              color: Colors.black, fontFamily: 'Roboto', letterSpacing: -0.41),
          titleMedium: TextStyle(
              height: 0.07,
              color: Colors.black,
              fontFamily: 'Roboto',
              letterSpacing: -0.41,
              fontSize: 18,
              fontWeight: FontWeight.w400),
          titleSmall: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w200),
          bodyLarge: TextStyle(
              height: 1.2,
              color: Colors.black,
              fontFamily: 'Roboto',
              letterSpacing: -0.41,
              fontWeight: FontWeight.w600,
              fontSize: 20),
          bodyMedium: TextStyle(
            // regular text
            color: Colors.black,
            fontFamily: 'Roboto',
            // letterSpacing: -0.41,
            fontWeight: FontWeight.w200,
            fontSize: 17,
          ),
          bodySmall: TextStyle(
              color: Colors.black, fontFamily: 'Roboto', letterSpacing: -0.41),
          labelLarge: TextStyle(
              color: Colors.black,
              fontFamily: 'Roboto',
              letterSpacing: -0.41,
              fontWeight: FontWeight.w600),
          labelMedium: TextStyle(
              // button text theme
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'Roboto',
              letterSpacing: -0.41,
              fontWeight: FontWeight.w400),
          labelSmall: TextStyle(
              color: Colors.black, fontFamily: 'Roboto', letterSpacing: -0.41),
          headlineLarge: TextStyle(
            color: Colors.brown,
            fontFamily: 'Roboto',
            letterSpacing: -0.41,
          )),
      primaryColor: MColors.secondaryGreen,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        textStyle: TextStyle(color: Colors.black),
        backgroundColor: MColors.secondaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      )));
}

TextStyle getBigTextStyle(
    {FontWeight weight = FontWeight.w600,
    Color color = MColors.black,
    double fontSize = 16}) {
  return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Roboto',
      fontWeight: weight);
}

TextStyle getMediumTextStyle(
    {FontWeight weight = FontWeight.w400,
    Color color = MColors.black,
    double fontSize = 16}) {
  return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Roboto',
      fontWeight: weight);
}

TextStyle getSmallTextStyle(
    {FontWeight weight = FontWeight.w200,
    Color color = MColors.black,
    double fontSize = 14}) {
  return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Roboto',
      fontWeight: weight);
}

TextStyle getHintTextStyle(
    {FontWeight weight = FontWeight.w200,
    Color color = MColors.darkGrey,
    double fontSize = 14}) {
  return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Roboto',
      fontWeight: weight);
}

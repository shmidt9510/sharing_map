import 'dart:io';

import 'package:flutter/material.dart';
// import 'screens/getstarted_screens/intro_screen.dart';
// import 'screens/home_screens/home_test.dart';
import 'screens/getstarted_screens/splash_screen.dart';
import 'screens/getstarted_screens/get_start.dart';
import 'utils/colors.dart';
import 'package:sharing_map/screens/home.dart';

void main() async => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Sharing Map",
        theme: ThemeData(
          secondaryHeaderColor: MColors.primaryGreen,
          primaryColor: MColors.secondaryGreen,
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage());
  }
}

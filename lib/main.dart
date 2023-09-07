import 'dart:io';

import 'package:flutter/material.dart';
// import 'screens/getstarted_screens/intro_screen.dart';
// import 'screens/home_screens/home_test.dart';
import 'screens/getstarted_screens/splash_screen.dart';
import 'screens/getstarted_screens/get_start.dart';
import 'utils/colors.dart';
import 'package:sharing_map/screens/home.dart';
import 'package:sharing_map/items/images/main_window.dart';

void main() async => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Container()
        // home: ImagePickerWidget(),
        );
  }
//     // return MaterialApp(
//     //     title: "Sharing Map",
//     //     theme: ThemeData(5
//     //       appBarTheme: AppBarTheme(
//     //         backgroundColor: MColors.secondaryGreen,
//     //         surfaceTintColor: MColors.primaryGreen,
//     //         actionsIconTheme: const IconThemeData(color: Colors.white),
//     //       ),
//     //       secondaryHeaderColor: MColors.primaryGreen,
//     //       primaryColor: MColors.secondaryGreen,
//     //     ),
//     //     debugShowCheckedModeBanner: false,
//     //     home: HomePage());
//   }
}

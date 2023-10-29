import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/router.dart';
import 'package:sharing_map/screens/add_new_item_page.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/utils/shared.dart';
// import 'screens/getstarted_screens/intro_screen.dart';
// import 'screens/home_screens/home_test.dart';
import 'screens/getstarted_screens/get_start.dart';
import 'utils/colors.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:sharing_map/test_page.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  await dotenv.load(fileName: ".env");
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final CommonController _commonController = Get.put(CommonController());
  final ItemController _itemsController = Get.put(ItemController());
  final UserController _usersController = Get.put(UserController());

  @override
  void initState() {
    _itemsController.onInit();
    _usersController.onInit();
    _commonController.onInit();
    debugPrint("on init " + SharedPrefs().userId);
    debugPrint("auth token " + SharedPrefs().authToken);
    debugPrint("refresh token " + SharedPrefs().refreshToken);
    super.initState();
  }

  @override
  void dispose() {
    _itemsController.dispose();
    _commonController.dispose();
    _usersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RouterStart(initLocation: _getInitPath());
  }

  String _getInitPath() {
    if (SharedPrefs().logged && SharedPrefs().authToken.length > 0) {
      return SMPath.home;
    }
    return SMPath.start;
  }
}

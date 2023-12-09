import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/router.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/utils/shared.dart';
// import 'screens/getstarted_screens/intro_screen.dart';
// import 'screens/home_screens/home_test.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:sharing_map/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.clear();
  await SharedPrefs().init();
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final CommonController _commonController = Get.put(CommonController());
  final ItemController _itemsController = Get.put(ItemController());
  final UserController _usersController = Get.put(UserController());
  WidgetsFlutterBinding.ensureInitialized();
  await _itemsController.fetchItems();
  await _usersController.CheckAuthorization();
  await _commonController.fetchItems();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final CommonController _commonController = Get.find<CommonController>();
  final ItemController _itemsController = Get.find<ItemController>();
  final UserController _usersController = Get.find<UserController>();

  @override
  void initState() {
    debugPrint("on init");
    _itemsController.onInit();
    _usersController.onInit();
    _commonController.onInit();
    debugPrint("on init end");
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
    return SMPath.home;
    String _path = SMPath.start;
    if (SharedPrefs().isFirstRun) {
      SharedPrefs().isFirstRun = false;
      return SMPath.start;
    }
    _usersController.CheckAuthorization().then((value) {
      if (!value) {
        return _path;
      }
      debugPrint("IS OK");
      _path = SMPath.home;
    });
    if (SharedPrefs().logged && SharedPrefs().authToken.length > 0) {
      debugPrint("IS LOGGED YAY!!");
      return SMPath.home;
    }
    return _path;
  }
}

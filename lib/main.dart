import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
  String _initPath = await _getInitPath(_usersController);
  debugPrint("I AM INIT PATH " + _initPath);
  WidgetsFlutterBinding.ensureInitialized();
  await _itemsController.fetchItems();
  await _usersController.CheckAuthorization();
  await _commonController.fetchItems();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(_initPath));
}

class App extends StatefulWidget {
  final String initPath;
  App(this.initPath);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final CommonController _commonController = Get.find<CommonController>();
  final ItemController _itemsController = Get.find<ItemController>();
  final UserController _usersController = Get.find<UserController>();

  @override
  void initState() {
    _itemsController.onInit();
    _usersController.onInit();
    _commonController.onInit();
    _commonController.getLocations(1);
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
    return RouterStart(initLocation: widget.initPath);
  }
}

Future<String> _getInitPath(UserController _usersController) async {
  if (SharedPrefs().isFirstRun) {
    SharedPrefs().isFirstRun = false;
    return SMPath.onboard;
  }
  var isAuhtorized = await _usersController.CheckAuthorization();
  if (!isAuhtorized) {
    return SMPath.start;
  }
  return SMPath.home;
}

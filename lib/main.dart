import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/router.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/utils/shared.dart';
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
  debugPrint("MY PATH IS $_initPath");
  SharedPrefs().initPath = _initPath;
  WidgetsFlutterBinding.ensureInitialized();
  await _commonController.fetchItems();
  await _itemsController.fetchItems();
  await _usersController.CheckAuthorization();
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
    super.initState();
    _itemsController.onInit();
    _usersController.onInit();
    _commonController.onInit();
    _commonController.getLocations(1);
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
  // return SMPath.profile;
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

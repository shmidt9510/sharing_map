import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/router.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/utils/init_path.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  final CommonController _commonController = Get.put(CommonController());
  final ItemController _itemsController = Get.put(ItemController());
  final UserController _usersController = Get.put(UserController());

  String _initPath = await checkInitPath(_usersController, _commonController);
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

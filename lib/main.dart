import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/size_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/router.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Future.wait([
    SharedPrefs().init(),
    dotenv.load(fileName: "env/prod.env"),
  ]);
  Get.put(CommonController());
  Get.put(SizeController());
  Get.put(ItemController());
  Get.put(UserController());
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
    super.initState();
    _itemsController.onInit();
    _usersController.onInit();
    _commonController.onInit();
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
    return RouterStart(initLocation: "/");
  }
}

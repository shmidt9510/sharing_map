import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/size_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/router.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/utils/navigator_key.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/services/core/http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (cert, host, port) => true; // Allow bad certificates
//   }
// }

void main() async {
  // HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();

  AppHttpClient().initialize(rootNavigatorKey);

  _initializeControllers();

  runApp(const App());
}

Future<void> _initializeApp() async {
  await Future.wait([
    SharedPrefs().init(),
    dotenv.load(fileName: "env/test.env"),
  ]);
}

void _initializeControllers() {
  Get.put(CommonController(), permanent: true);
  Get.put(SizeController(), permanent: true);
  Get.put(ItemController(), permanent: true);
  Get.put(UserController(), permanent: true);
}

class App extends StatefulWidget {
  const App({super.key});

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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/init_path.dart';
import 'package:sharing_map/utils/shared.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final CommonController _commonController = Get.find<CommonController>();
  final ItemController _itemsController = Get.find<ItemController>();
  final UserController _usersController = Get.find<UserController>();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    _performRequests();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _performRequests() async {
    try {
      String _initPath = await checkInitPath();
      SharedPrefs().initPath = _initPath;
      if (_initPath == SMPath.noNetwork) {
        GoRouter.of(context).go(_initPath);
        return;
      }
      await Future.wait([
        _commonController.fetchItems(),
      ]);
      if (SharedPrefs().logged && SharedPrefs().userId.isNotEmpty) {
        await _usersController.GetMyself();
      }
      if (SharedPrefs().chosenCity != -1) {
        _commonController.getLocations(SharedPrefs().chosenCity, false);
      }
      await _itemsController.onSplashScreen();
    } catch (e) {
      SharedPrefs().initPath = SMPath.noNetwork;
    }
    SharedPrefs().configInit = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoRouter.of(context).go(SharedPrefs().initPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _animation,
            child: SvgPicture.asset(
              "assets/images/sharing_map_logo.svg",
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
// import 'package:sharing_map/screens/register_screens/registration_screen.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/init_path.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/loading_button.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  UserController _userController = Get.find<UserController>();
  final CommonController _commonController = Get.put(CommonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: MColors.primaryGreen,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  "assets/images/sharing_map_logo.svg",
                  height: 200,
                ),
              ),
              SizedBox(
                height: 100.0,
              ),
              Text('Пожалуйста проверьте подключение к интернету',
                  style: getBigTextStyle(color: MColors.white)),
              SizedBox(
                height: 20.0,
              ),
              LoadingButton("Проверить", () async {
                var _initPath =
                    await checkInitPath(_userController, _commonController);
                if (_initPath != SMPath.noNetwork) {
                  await _commonController.fetchItems();
                }
                if (_initPath.startsWith("/")) {
                  GoRouter.of(context).go(_initPath);
                } else {
                  GoRouter.of(context).go(SMPath.home);
                }
              }, color: MColors.darkGreen, height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

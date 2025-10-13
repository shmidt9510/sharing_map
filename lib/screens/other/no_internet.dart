import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/services/common_service.dart';
import 'package:sharing_map/theme.dart';
// import 'package:sharing_map/screens/register_screens/registration_screen.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/loading_button.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  final UserController _usersController = Get.find<UserController>();
  final CommonController _commonController = Get.put(CommonController());
  final ItemController _itemsController = Get.put(ItemController());
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
              Text('Пожалуйста, проверьте подключение к интернету',
                  textAlign: TextAlign.center,
                  style: getBigTextStyle(color: MColors.white)),
              SizedBox(
                height: 20.0,
              ),
              LoadingButton("Повторить", () async {
                if (await _commonController.checkInternet()) {
                  GoRouter.of(context).go("/");
                } else {
                  try {
                    await CommonWebService.checkInternetConnectivity();
                  } catch (e) {
                    showErrorScaffold(context,
                        "Нет интернета или наш сервер не отвечает 😨 ");
                  }
                }
              }, color: MColors.darkGreen, height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

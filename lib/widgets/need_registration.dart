import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/allWidgets.dart';

class NeedRegistration extends StatelessWidget {
  Widget child;

  UserController _userController = Get.find<UserController>();
  NeedRegistration(this.child);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userController.GetMyself(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(children: [
                Text("Чтобы редактировать профиль, надо зарегистрироваться"),
                SizedBox(
                  height: 10,
                ),
                getButton(context, "Регистрация", () {
                  GoRouter.of(context)
                      .go(SMPath.start + "/" + SMPath.registration);
                }, color: MColors.grey1),
                SizedBox(
                  height: 10,
                ),
                getButton(context, "Войти", () {
                  GoRouter.of(context).go(SMPath.start + "/" + SMPath.login);
                })
              ]),
            );
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          _userController.myself(snapshot.data as User);
          return child;
        });
  }
}

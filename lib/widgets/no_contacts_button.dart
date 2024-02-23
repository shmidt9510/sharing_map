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

class NoContactButton extends StatelessWidget {
  UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _userController.myContacts.isEmpty
        ? Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: getMediumTextStyle(),
                  backgroundColor: MColors.red2,
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  GoRouter.of(context).go(SMPath.profile);
                },
                child: Center(
                  child: Text.rich(TextSpan(
                    text:
                        'Пожалуйста, проверьте, чтобы в профиле был заполнен хотя бы один контакт ',
                    style: getMediumTextStyle(),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Перейти в профиль',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                      // can add more TextSpans here...
                    ],
                  )),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          )
        : Container());
  }
}

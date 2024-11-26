import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';

class NoContactButton extends StatelessWidget {
  UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: getMediumTextStyle(),
            backgroundColor: MColors.red2,
            minimumSize: Size.fromHeight(100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            GoRouter.of(context).go(SMPath.myItems + "/" + SMPath.profile);
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
              ],
            )),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

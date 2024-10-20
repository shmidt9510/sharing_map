import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/screens/items/item_widgets_self_profile.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/user/page/user_actions.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/need_registration.dart';

class MyItemsPage extends StatefulWidget {
  @override
  _MyItemsPageState createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
  final UserController _userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: MColors.secondaryGreen,
            onPressed: () => GoRouter.of(context).go(SMPath.home),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: SharedPrefs().logged
              ? [
                  Spacer(
                    flex: 14,
                  ),
                  Expanded(flex: 2, child: UserActionsWidget()),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () {
                        GoRouter.of(context)
                            .go(SMPath.myItems + "/" + SMPath.profile);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        side: BorderSide(width: 2, color: MColors.darkGreen),
                        padding: EdgeInsets.all(0), // Remove default padding
                      ),
                      child: ClipOval(
                        child: Container(
                            width: 25, // Width of the circular button
                            height: 25, // Height of the circular button
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: _userController.userProfilePicture.value),
                      ),
                    ),
                  ),
                  Spacer()
                ]
              : null,
        ),
        body: SharedPrefs().logged
            ? SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      "Мои объявления",
                      style: getBigTextStyle(),
                    )),
                    const SizedBox(height: 24),
                    ItemsListViewSelfProfile()
                  ],
                ),
              )
            : NeedRegistration());
  }
}

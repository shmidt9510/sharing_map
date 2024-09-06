import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          actions: SharedPrefs().logged ? [UserActionsWidget()] : null,
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

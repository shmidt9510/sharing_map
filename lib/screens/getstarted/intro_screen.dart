import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/path.dart';
// import 'package:sharing_map/screens/register_screens/registration_screen.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/strings.dart';
import 'package:sharing_map/widgets/allWidgets.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _showCloseAppDialog();
        return Future.value(true);
      },
      child: Scaffold(
        body: primaryContainer(
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: SvgPicture.asset(
                    "assets/images/sharing_map_logo.svg",
                    height: 200,
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  child: Text(
                    dotenv.get('S3_BUCKET'),
                    style: boldFont(MColors.primaryWhiteSmoke, 30.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: Text(
                    "Привет",
                    style: boldFont(MColors.primaryWhiteSmoke, 30.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Text(
                    Strings.onBoardTitle_sub1,
                    style: normalFont(MColors.primaryWhiteSmoke, 18.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 150.0,
          color: MColors.primaryGreen,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              secondaryButtonGreen(
                Text(
                  "Войти",
                  style: boldFont(MColors.appBarDark, 16.0),
                ),
                () {
                  GoRouter.of(context).go(SMPath.start + "/" + SMPath.login);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              secondaryButtonGreenSmoke(
                Text(
                  "Зарегестрироваться",
                  style: boldFont(MColors.appBarDark, 16.0),
                ),
                () {
                  GoRouter.of(context)
                      .go(SMPath.start + "/" + SMPath.registration);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCloseAppDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              "Are you sure you want to leave?",
              style: normalFont(MColors.textGrey, 14.0),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: normalFont(MColors.textGrey, 14.0),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  "Leave",
                  style: normalFont(Colors.redAccent, 14.0),
                ),
              ),
            ],
          );
        });
  }
}

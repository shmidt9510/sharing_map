import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/path.dart';
// import 'package:sharing_map/screens/register_screens/registration_screen.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
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
                getButton(context, "Войти", () {
                  GoRouter.of(context).go(SMPath.start + "/" + SMPath.login);
                }, color: MColors.secondaryGreen, height: 50),
                SizedBox(
                  height: 20.0,
                ),
                getButton(context, "Зарегистрироваться", () {
                  GoRouter.of(context)
                      .go(SMPath.start + "/" + SMPath.registration);
                }, color: MColors.white, height: 50),
                const SizedBox(height: 20),
                getButton(context, "Продолжить без регистрации", () {
                  GoRouter.of(context).go(SMPath.home);
                }, color: MColors.lightGrey),
                // Text(SharedPrefs().initPath.toString() +
                //     "_" +
                //     SharedPrefs().isFirstRun.toString() +
                //     "_" +
                //     SharedPrefs().logged.toString()),
              ],
            ),
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
              "Вы точно уверены, что хотите выйти?",
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                child: Text(
                  "Нет",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  "Да",
                ),
              ),
            ],
          );
        });
  }
}

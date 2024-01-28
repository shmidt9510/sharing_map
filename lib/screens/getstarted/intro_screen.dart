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
                SizedBox(height: 30.0),
                // Text(SharedPrefs().refreshToken),
                // Text(SharedPrefs().initPath.toString()),
                // Text(SharedPrefs().isFirstRun.toString()),
                // Text(SharedPrefs().logged.toString()),
                // Text(SharedPrefs().authToken),
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
            children: [
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          MColors.secondaryGreen),
                    ),
                onPressed: () async {
                  GoRouter.of(context).go(SMPath.start + "/" + SMPath.login);
                },
                child: Text(
                  "Войти",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(MColors.white),
                    ),
                onPressed: () async {
                  GoRouter.of(context)
                      .go(SMPath.start + "/" + SMPath.registration);
                },
                child: Text(
                  "Зарегистрироваться",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
// import 'package:sharing_map/widgets/textInputWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sharing_map/widgets/allWidgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final prefs = SharedPreferences.getInstance().then((value) => );
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  UserController _userController = Get.find<UserController>();

  var passwordFocusNode = FocusNode();
  var mailFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BackButton(color: MColors.white),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      backgroundColor: MColors.primaryGreen,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              getTextField(_controllerUsername, "Введите свой email",
                  (String? value) {
                if (value?.length == 0) {
                  return null;
                }
                return EmailValidator.validate(value ?? "")
                    ? null
                    : "Неверный формат почты";
              },
                  keyboardType: TextInputType.emailAddress,
                  focuseNode: mailFocusNode,
                  hintColor: MColors.errorLightRed),
              const SizedBox(height: 10),
              getPasswordTextField(
                  _controllerPassword, "пароль", _obscurePassword, () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              }, (String? value) {
                if (value == null || value.isEmpty || value.length < 8) {
                  return "Введите пароль больше 8 символов";
                }
                return null;
              },
                  focuseNode: passwordFocusNode,
                  hintColor: MColors.errorLightRed),
              const SizedBox(height: 60),
              TextButton(
                onPressed: () async {
                  GoRouter.of(context)
                      .go(SMPath.start + "/" + SMPath.forgetPasswordMail);
                },
                child: Text(
                  "Забыли пароль?",
                  style: getMediumTextStyle(color: MColors.white).copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: MColors.white),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Нет аккаунта?",
                        style: getMediumTextStyle(color: MColors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          GoRouter.of(context)
                              .go(SMPath.start + "/" + SMPath.registration);
                        },
                        child: Text(
                          "Зарегистрируйтесь",
                          style: getMediumTextStyle(color: MColors.white)
                              .copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: MColors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  getButton(context, "Войти", () async {
                    if (await _userController.Login(
                        _controllerUsername.text, _controllerPassword.text)) {
                      GoRouter.of(context).go(SMPath.home);
                    } else {
                      showErrorScaffold(context, 'Не получилось :(');
                    }
                  }, color: MColors.secondaryGreen),
                  const SizedBox(height: 20),
                  getButton(context, "Продолжить без регистрации", () {
                    GoRouter.of(context).go(SMPath.home);
                  }, color: MColors.lightGrey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}

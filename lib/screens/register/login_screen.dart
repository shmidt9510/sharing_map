import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
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
              SizedBox(
                height: 44,
                child: getTextField(_controllerUsername, "Введите свой email",
                    (String? value) {
                  return EmailValidator.validate(value ?? "")
                      ? null
                      : "Пожалуйста введите валидную почту";
                }, keyboardType: TextInputType.emailAddress),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  height: 44,
                  child: getPasswordTextField(
                      _controllerPassword, "Пароль", _obscurePassword, () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }, (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Введите пароль";
                    }
                    return null;
                  })),
              const SizedBox(height: 60),
              TextButton(
                onPressed: () async {
                  GoRouter.of(context)
                      .go(SMPath.start + "/" + SMPath.forgetPasswordMail);
                },
                child: const Text(
                  "Забыли пароль?",
                  style: TextStyle(
                      decorationColor: MColors.white,
                      color: MColors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Нет аккаунта?",
                          style: TextStyle(
                              color: MColors.white,
                              fontWeight: FontWeight.w400)),
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          GoRouter.of(context)
                              .go(SMPath.start + "/" + SMPath.registration);
                        },
                        child: const Text(
                          "Зарегистрируйтесь",
                          style: TextStyle(
                              decorationColor: MColors.white,
                              color: MColors.white,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w400),
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
                  }, color: MColors.secondaryGreen, height: 46),
                  const SizedBox(height: 20),
                  getButton(context, "Продолжить без регистрации", () {
                    GoRouter.of(context).go(SMPath.home);
                  }, color: MColors.lightGrey, height: 46),
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

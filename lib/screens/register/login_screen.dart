import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/utils/colors.dart';
// import 'package:sharing_map/widgets/textInputWidget.dart';
import 'package:email_validator/email_validator.dart';

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
              TextFormField(
                focusNode: null,
                controller: _controllerUsername,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "Введите свой email",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MColors.secondaryGreen),
                      borderRadius: BorderRadius.circular(10)),
                ),
                // onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (!EmailValidator.validate(value ?? "")) {
                    return "Пожалуйста введите валидную почту";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Пароль",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MColors.secondaryGreen),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Введите пароль";
                  }
                  //  else if (value != _boxAccounts.get(_controllerUsername.text)) {
                  //   return "Wrong password.";
                  // }

                  return null;
                },
              ),
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
                      decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Нету аккаунта?",
                          style: TextStyle(color: MColors.grey1)),
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          GoRouter.of(context)
                              .go(SMPath.start + "/" + SMPath.registration);
                        },
                        child: const Text(
                          "Зарегестрируйтесь",
                          style: TextStyle(
                              decorationColor: MColors.grey1,
                              color: MColors.grey1,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MColors.secondaryGreen,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      var result = await _userController.Login(
                          _controllerUsername.text, _controllerPassword.text);
                      if (result) {
                        GoRouter.of(context).go(SMPath.home);
                      } else {
                        SnackBar snackBar = SnackBar(
                          content: const Text('Не получилось :('),
                          action: SnackBarAction(
                            label: 'Закрыть',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      "Войти",
                      style: TextStyle(color: MColors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MColors.lightGrey,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      GoRouter.of(context).go(SMPath.home);
                    },
                    child: const Text(
                      "Продолжить без регистрации",
                      style: TextStyle(color: MColors.black),
                    ),
                  ),
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

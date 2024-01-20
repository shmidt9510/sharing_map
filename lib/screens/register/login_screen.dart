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
              SizedBox(
                height: 44,
                child: TextFormField(
                  focusNode: null,
                  controller: _controllerUsername,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white,
                    filled: true,
                    labelText: "Введите свой email",
                    labelStyle: TextStyle(fontWeight: FontWeight.w400),
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
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 44,
                child: TextFormField(
                  controller: _controllerPassword,
                  focusNode: _focusNodePassword,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Пароль",
                    labelStyle: TextStyle(fontWeight: FontWeight.w400),
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
                    return null;
                  },
                ),
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
                  ElevatedButton(
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size.fromHeight(46)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MColors.secondaryGreen),
                            ),
                    // ElevatedButton.styleFrom(
                    //   backgroundColor: MColors.secondaryGreen,
                    //   minimumSize: const Size.fromHeight(50),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    // ),
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
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      "Войти",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size.fromHeight(46)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MColors.lightGrey),
                            ),
                    onPressed: () {
                      GoRouter.of(context).go(SMPath.home);
                    },
                    child: Text(
                      "Продолжить без регистрации",
                      style: Theme.of(context).textTheme.labelMedium,
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

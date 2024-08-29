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
import 'package:url_launcher/url_launcher.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _LoginState();
}

class _LoginState extends State<RegistrationScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final prefs = SharedPreferences.getInstance().then((value) => );
  // final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerMail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  UserController _userController = Get.find<UserController>();
  bool _isChecked = false;

  bool _obscurePassword = true;
  var mailFocusNode = FocusNode();
  var passwordFocusNode = FocusNode();
  var nameFocusNode = FocusNode();
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
              const SizedBox(height: 24),
              getTextField(_controllerMail, "Введите свой email",
                  (String? value) {
                if (value == null) {
                  return null;
                }
                if (value.length == 0) {
                  return null;
                }
                if (!EmailValidator.validate(value.replaceAll(' ', ''))) {
                  return "Пожалуйста, введите почту";
                }
                return null;
              },
                  keyboardType: TextInputType.emailAddress,
                  focuseNode: mailFocusNode,
                  hintColor: MColors.errorLightRed),
              const SizedBox(height: 10),
              getTextField(_controllerUsername, "Ваше имя", (String? value) {
                if (value?.isEmpty ?? false) {
                  return "Напишите ваше имя";
                }
                if (_controllerPassword.text == value) {
                  return "Пароль не должен совпадать с вашим именем";
                }
                return null;
              },
                  keyboardType: TextInputType.name,
                  focuseNode: nameFocusNode,
                  hintColor: MColors.errorLightRed),
              const SizedBox(height: 60),
              getPasswordTextField(
                  _controllerPassword,
                  "Пароль",
                  _obscurePassword,
                  () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }), (String? value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                if (value.length < 8) {
                  return "Пожалуйста введите от 8 символов";
                }
                return null;
              },
                  focuseNode: passwordFocusNode,
                  hintColor: MColors.errorLightRed),
              const SizedBox(height: 60),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.black,
                    focusColor: MColors.lightGreen,
                    activeColor: MColors.lightGreen,
                    fillColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return MColors.darkGreen;
                      }
                      return MColors.lightGreen;
                    }),
                    // fillColor: MColors.white,,
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                  SizedBox(
                    width: context.width * 0.6,
                    child: Text(
                      'Я принимаю условия пользовательского соглашения',
                      maxLines: 2,
                      style: TextStyle(color: MColors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                  child: Text('Посмотреть условия пользовательского соглашения',
                      style: getMediumTextStyle(color: MColors.white).copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: MColors.white)),
                  onTap: () => launchUrl(Uri.parse(
                      'https://docs.google.com/document/d/1dVBC3nqMVMLXrZ6H6h3d340dCDHdBPxivykTD_Vfa_E/edit'))),
              const SizedBox(height: 20),
              Column(
                children: [
                  getButton(context, "Зарегистрироваться", () async {
                    if (!_isChecked) {
                      showErrorScaffold(context,
                          'Нужно подтвердить условия пользовательского соглашения');
                      return;
                    }
                    if (!(_formKey.currentState?.validate() ?? false)) {
                      showErrorScaffold(context, "Не получилось :(");
                      return;
                    }
                    var mail = _controllerMail.text.replaceAll(' ', '');
                    var result = await _userController.Signup(mail,
                        _controllerUsername.text, _controllerPassword.text);
                    if (result == SignupResult.ok) {
                      GoRouter.of(context).go(
                        SMPath.start +
                            "/" +
                            SMPath.registration +
                            "/" +
                            SMPath.registrationCode,
                      );
                    } else if (result == SignupResult.emailTaken) {
                      showErrorScaffold(context, result.statusMessage,
                          label: "Сбросить пароль", onPressed: () {
                        GoRouter.of(context).go(
                          SMPath.start + "/" + SMPath.forgetPasswordMail,
                        );
                      });
                    } else {
                      showErrorScaffold(context, result.statusMessage);
                    }
                  }),
                  const SizedBox(height: 10),
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
    // _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}

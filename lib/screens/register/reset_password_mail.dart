import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
// import 'package:sharing_map/widgets/textInputWidget.dart';

class ResetPasswordMailScreen extends StatefulWidget {
  const ResetPasswordMailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordMailScreen> createState() => _ResetPasswordMailState();
}

class _ResetPasswordMailState extends State<ResetPasswordMailScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final prefs = SharedPreferences.getInstance().then((value) => );
  final TextEditingController _controllerUsername = TextEditingController();

  late UserController _userController;

  @override
  void initState() {
    super.initState();
    _userController = Get.find<UserController>();
  }

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Сбросить пароль")),
      floatingActionButton: BackButton(color: MColors.white),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      backgroundColor: MColors.primaryGreen,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              getTextField(_controllerUsername, "Введите свой email", (value) {
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
                  hintColor: MColors.errorLightRed),
              const SizedBox(height: 20),
              getButton(context, 'Поменять', () async {
                if (_formKey.currentState?.validate() ?? false) {
                  var mail = _controllerUsername.text.replaceAll(' ', '');
                  if (await _userController.ResetPasswordStart(mail)) {
                    GoRouter.of(context)
                        .go(SMPath.start + "/" + SMPath.forgetPasswordCode);
                  } else {
                    showSnackBar(context, 'Не получилось :(');
                  }
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }
}

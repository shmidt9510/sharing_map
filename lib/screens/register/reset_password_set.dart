import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/allWidgets.dart';

class ResetPasswordSetScreen extends StatefulWidget {
  const ResetPasswordSetScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordSetScreen> createState() => _ResetPasswordSetState();
}

class _ResetPasswordSetState extends State<ResetPasswordSetScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final prefs = SharedPreferences.getInstance().then((value) => );
  final TextEditingController _controllerPassword = TextEditingController();
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
              getPasswordTextField(
                  _controllerPassword, "Введите пароль", _obscurePassword, () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              }, (value) {
                if (value == null || value.isEmpty) {
                  return;
                }
                return null;
              }),
              const SizedBox(height: 20),
              getButton(context, "Поменять", () async {
                var result = await _userController.ResetPassword(
                    _controllerPassword.text);

                if (result) {
                  _userController.setToken('');
                  GoRouter.of(context).go(SMPath.start + "/" + SMPath.login);
                } else {
                  showSnackBar(context, 'Не получилось :(');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerPassword.dispose();
    super.dispose();
  }
}

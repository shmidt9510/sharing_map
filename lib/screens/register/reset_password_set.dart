import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/utils/colors.dart';
// import 'package:sharing_map/widgets/textInputWidget.dart';

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
              TextFormField(
                controller: _controllerPassword,
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
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MColors.secondaryGreen,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  debugPrint("here OOOO");
                  var result = await _userController.ResetPassword(
                      _controllerPassword.text);

                  if (result) {
                    _userController.setToken('');
                    GoRouter.of(context).go(SMPath.start + "/" + SMPath.login);
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
                  "Поменять",
                  style: TextStyle(color: MColors.black),
                ),
              ),
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

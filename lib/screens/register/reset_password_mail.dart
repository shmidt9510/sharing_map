import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/utils/colors.dart';
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
                  if (_formKey.currentState?.validate() ?? false) {
                    if (await _userController.ResetPasswordStart(
                        _controllerUsername.text)) {
                      var snackBar = SnackBar(
                        content: const Text('Отправили вам код в письме)'),
                        action: SnackBarAction(
                          label: 'Закрыть',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      GoRouter.of(context)
                          .go(SMPath.start + "/" + SMPath.forgetPasswordCode);
                    } else {
                      var snackBar = SnackBar(
                        content: const Text('Не получилось :('),
                        action: SnackBarAction(
                          label: 'Закрыть',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
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
    _controllerUsername.dispose();
    super.dispose();
  }
}

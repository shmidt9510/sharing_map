import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
// import 'package:sharing_map/widgets/textInputWidget.dart';
import 'package:email_validator/email_validator.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
  }

  bool _onEditing = true;

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.height / 3),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Мы отправили вам код на почту',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
          Center(
            child: VerificationCode(
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
              keyboardType: TextInputType.number,
              length: 4,
              margin: const EdgeInsets.all(12),
              onCompleted: (String value) {
                setState(() {
                  _waitSignupResult(value, context);
                });
              },
              onEditing: (bool value) {
                setState(() {
                  _onEditing = value;
                });
                if (!_onEditing) FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _waitSignupResult(String code, BuildContext context) async {
    bool result = await _userController.SignupConfirm(code);
    if (!result) {
      var snackBar = SnackBar(
        content: const Text('Что-то пошло не так'),
        action: SnackBarAction(
          label: 'Закрыть',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      debugPrint(SharedPrefs().userId);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    GoRouter.of(context).go(SMPath.home);
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

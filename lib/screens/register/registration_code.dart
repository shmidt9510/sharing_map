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

class RegistrationCodeScreen extends StatefulWidget {
  const RegistrationCodeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RegistrationCodeScreen> createState() => _LoginState();
}

class _LoginState extends State<RegistrationCodeScreen> {
  UserController _userController = Get.find<UserController>();

  bool _onEditing = true;
  String? _code;

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Введите код 1112)'),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Enter your code',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          VerificationCode(
            textStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).primaryColor),
            keyboardType: TextInputType.number,
            underlineColor: Colors
                .amber, // If this is null it will use primaryColor: Colors.red from Theme
            length: 4,
            cursorColor:
                Colors.green, // If this is null it will default to the ambient
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: _onEditing
                  ? const Text('Please enter full code')
                  : Text('Your code: $_code'),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _waitSignupResult(String code, BuildContext context) async {
    bool result = await _userController.SignupConfirm(code);
    if (!result) {
      var snackBar = SnackBar(
        content: const Text('Ура можно залогиниться'),
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
    var snackBar = SnackBar(
      content: const Text('Ура можно залогиниться'),
      action: SnackBarAction(
        label: 'Закрыть',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    debugPrint(SharedPrefs().userId);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

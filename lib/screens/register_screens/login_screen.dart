import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/screens/home.dart';
import 'package:sharing_map/screens/register_screens/reset_screen.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/textFieldFormaters.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/textInputWidget.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<_LoginScreenState>();

  String _email = "";
  String _password = "";
  String _error = "";
  bool _autoValidate = false;
  bool _isButtonDisabled = false;
  bool _obscureText = true;
  bool _isEnabled = true;
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: BackButton(
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
      backgroundColor: MColors.primaryGreen,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: primaryContainer(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 100.0),
                child: Text(
                  "Войдите в свой аккаунт",
                  style: boldFont(MColors.primaryWhite, 38.0),
                  textAlign: TextAlign.start,
                ),
              ),

              SizedBox(height: 20.0),

              SizedBox(height: 10.0),

              SizedBox(height: 10.0),

              //FORM
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "Ваш email-адрес",
                            style: normalFont(MColors.whiteText, 16),
                          ),
                        ),
                        TextInputField(
                            mailController,
                            null,
                            "share@map.com",
                            _isEnabled,
                            EmailValiditor.validate,
                            _autoValidate,
                            true,
                            TextInputType.emailAddress,
                            null,
                            null,
                            0.50,
                            context.theme),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "Ваш пароль",
                            style: normalFont(MColors.whiteText, 16),
                          ),
                        ),
                        TextInputField(
                            passwordController,
                            null,
                            "password",
                            _isEnabled,
                            PasswordValiditor.validate,
                            _autoValidate,
                            false,
                            TextInputType.text,
                            null,
                            SizedBox(
                              height: 15.0,
                              width: 70.0,
                              child: RawMaterialButton(
                                onPressed: _toggle,
                                child: Text(
                                  _obscureText ? "Показать" : "Скрыть",
                                  style: TextStyle(
                                    color: MColors.secondaryGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            0.50,
                            context.theme),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_box,
                          color: MColors.secondaryGreen,
                        ),
                        SizedBox(width: 5.0),
                        Container(
                          child: Text(
                            "Запомнить меня.",
                            style: normalFont(MColors.textDark, 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    // secondaryButtonGreen(
                    //         //if button is loading
                    //         progressIndicator(Colors.white),
                    //         null,
                    //       )
                    secondaryButtonGreen(
                        Text(
                          "Войти",
                          style: boldFont(
                            MColors.primaryWhite,
                            16.0,
                          ),
                        ), () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (BuildContext context) => HomePage(),
                        ),
                      );
                    }),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => ResetScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Забыли пароль?",
                        style: normalFont(MColors.textGrey, 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _submit() async {
    final form = formKey.currentState;

    try {
      // final auth = MyProvider.of(context).auth;
      if (form?.validate() ?? false) {
        form?.save();

        if (mounted) {
          setState(() {
            _isButtonDisabled = true;
            _isEnabled = false;
          });
        }

        String uid =
            '111'; //await auth.signInWithEmailAndPassword(_email, _password);
        print("Signed in with $uid");

        // Navigator.of(context).pushReplacement(
        //   CupertinoPageRoute(
        //     builder: (_) => HomeView(),
        //   ),
        // );
      } else {
        setState(() {
          _autoValidate = true;
          _isEnabled = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "error";
          _isButtonDisabled = false;
          _isEnabled = true;
        });
      }

      print("ERRORR ==>");
      print(e);
    }
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.redAccent,
              ),
            ),
            Expanded(
              child: Text(
                _error,
                style: normalFont(Colors.redAccent, 15.0),
              ),
            ),
          ],
        ),
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: MColors.primaryWhiteSmoke,
          border: Border.all(width: 1.0, color: Colors.redAccent),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }
}

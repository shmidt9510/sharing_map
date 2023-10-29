  //  // appBar: AppBar(
  //     //   leading: BackButton(
  //     //     onPressed: () => Navigator.of(context).pop(),
  //     //   ),
  //     // ),
  //     backgroundColor: MColors.primaryGreen,
  //     body: SingleChildScrollView(
  //       physics: BouncingScrollPhysics(),
  //       child: primaryContainer(
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: <Widget>[
  //             Container(
  //               padding: const EdgeInsets.only(top: 100.0),
  //               child: Text(
  //                 "Войдите в свой аккаунт",
  //                 style: boldFont(MColors.primaryWhite, 38.0),
  //                 textAlign: TextAlign.start,
  //               ),
  //             ),

  //             SizedBox(height: 20.0),

  //             SizedBox(height: 10.0),

  //             SizedBox(height: 10.0),

  //             //FORM
  //             Form(
  //               key: formKey,
  //               autovalidateMode: AutovalidateMode.onUserInteraction,
  //               child: Column(
  //                 children: <Widget>[
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Container(
  //                         padding: const EdgeInsets.only(bottom: 5.0),
  //                         child: Text(
  //                           "Ваш email-адрес",
  //                           style: normalFont(MColors.whiteText, 16),
  //                         ),
  //                       ),
  //                       TextFormField(
  //                         obscureText: true,
  //                         validator: (val) =>
  //                             !EmailValidator.validate(val ?? "", true)
  //                                 ? 'Введите правильный email'
  //                                 : null,
  //                         decoration: InputDecoration(
  //                           labelText: 'Введите email',
  //                           helperText: 'Введите email',
  //                         ),
  //                       ),
  //                       // TextInputField(
  //                       //     mailController,
  //                       //     null,
  //                       //     "share@map.com",
  //                       //     _isEnabled,
  //                       //     EmailValiditor.validate,
  //                       //     _autoValidate,
  //                       //     true,
  //                       //     TextInputType.emailAddress,
  //                       //     null,
  //                       //     null,
  //                       //     0.50,
  //                       //     context.theme),
  //                     ],
  //                   ),
  //                   SizedBox(height: 20.0),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Container(
  //                         padding: const EdgeInsets.only(bottom: 5.0),
  //                         child: Text(
  //                           "Ваш пароль",
  //                           style: normalFont(MColors.whiteText, 16),
  //                         ),
  //                       ),
  //                       PasswordField(),
  //                     ],
  //                   ),
  //                   SizedBox(height: 20.0),
  //                   Row(
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.check_box,
  //                         color: MColors.secondaryGreen,
  //                       ),
  //                       SizedBox(width: 5.0),
  //                       Container(
  //                         child: Text(
  //                           "Запомнить меня.",
  //                           style: normalFont(MColors.textDark, 16),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 20.0),
  //                   // secondaryButtonGreen(
  //                   //         //if button is loading
  //                   //         progressIndicator(Colors.white),
  //                   //         null,
  //                   //       )
  //                   secondaryButtonGreen(
  //                       Text(
  //                         "Войти",
  //                         style: boldFont(
  //                           MColors.primaryWhite,
  //                           16.0,
  //                         ),
  //                       ), () {
  //                     Navigator.of(context).pushReplacement(
  //                       CupertinoPageRoute(
  //                         builder: (BuildContext context) => HomePage(),
  //                       ),
  //                     );
  //                   }),
  //                   SizedBox(height: 20.0),
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).push(
  //                         CupertinoPageRoute(
  //                           builder: (_) => ResetScreen(),
  //                         ),
  //                       );
  //                     },
  //                     child: Text(
  //                       "Забыли пароль?",
  //                       style: normalFont(MColors.textGrey, 16),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
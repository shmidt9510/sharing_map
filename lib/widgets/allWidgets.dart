import 'package:flutter/material.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';

Widget secondaryButtonGreen(
  Widget buttonChild,
  void Function()? onPressed,
) {
  return SizedBox(
    width: double.infinity,
    height: 50.0,
    child: RawMaterialButton(
      elevation: 0.0,
      hoverElevation: 0.0,
      focusElevation: 0.0,
      highlightElevation: 0.0,
      fillColor: MColors.secondaryGreen,
      child: buttonChild,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
    ),
  );
}

Widget secondaryButtonGreenSmoke(
  Widget buttonChild,
  void Function() onPressed,
) {
  return SizedBox(
    width: double.infinity,
    height: 50.0,
    child: RawMaterialButton(
      elevation: 0.0,
      hoverElevation: 0.0,
      focusElevation: 0.0,
      highlightElevation: 0.0,
      fillColor: MColors.white,
      child: buttonChild,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
    ),
  );
}

Widget getButton(
    BuildContext context, String labelText, void Function() onPressed,
    {Color color = MColors.secondaryGreen,
    double height = 50,
    TextStyle? textStyle}) {
  if (textStyle == null) {
    textStyle = getMediumTextStyle();
  }
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      textStyle: textStyle,
      backgroundColor: color,
      minimumSize: Size.fromHeight(height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: onPressed,
    child: Center(
      child: Text(
        textAlign: TextAlign.center,
        labelText,
        style: textStyle,
      ),
    ),
  );
}

Widget getTextField(TextEditingController controller, String label,
    String? Function(String? value) validator,
    {TextInputType? keyboardType,
    int minLines = 1,
    int maxLines = 1,
    FocusNode? focuseNode,
    Color? hintColor,
    int? maxLength = null}) {
  var _focusNode = focuseNode ?? FocusNode();
  var _capitalization = (keyboardType == TextInputType.emailAddress)
      ? TextCapitalization.none
      : TextCapitalization.sentences;
  return TextFormField(
    onTapOutside: (PointerDownEvent e) {
      _focusNode.unfocus();
    },
    focusNode: _focusNode,
    minLines: minLines,
    maxLines: maxLines,
    controller: controller,
    keyboardType: keyboardType,
    textCapitalization: _capitalization,
    style: getMediumTextStyle(),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      hintStyle: getMediumTextStyle(),
      labelStyle: getMediumTextStyle(),
      errorStyle: hintColor != null
          ? getHintTextStyle().copyWith(color: hintColor)
          : null,
      contentPadding: EdgeInsets.all(10),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MColors.secondaryGreen),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    maxLength: maxLength,
    validator: validator,
  );
}

Widget getPasswordTextField(
    TextEditingController controller,
    String labelText,
    bool obscurePassword,
    void Function() onIconPressed,
    String? Function(String? value) validator,
    {FocusNode? focuseNode,
    Color? hintColor}) {
  var _focusNode = focuseNode ?? FocusNode();
  return TextFormField(
    onTapOutside: (PointerDownEvent e) {
      _focusNode.unfocus();
    },
    focusNode: _focusNode,
    style: getMediumTextStyle(),
    controller: controller,
    obscureText: obscurePassword,
    keyboardType: TextInputType.visiblePassword,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(10),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Colors.white,
      labelText: "Пароль",
      errorStyle: hintColor != null
          ? getHintTextStyle().copyWith(color: hintColor)
          : null,
      hintStyle: getMediumTextStyle(),
      labelStyle: getMediumTextStyle(),
      suffixIcon: IconButton(
          onPressed: onIconPressed,
          icon: obscurePassword
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
      if (value.length < 8) {
        return "Больше восьми символов";
      }
      return null;
    },
  );
}

void showErrorScaffold(BuildContext context, String errorMessage,
    {String label = "Закрыть", void Function()? onPressed = null}) {
  SnackBar snackBar = SnackBar(
    content: Text(errorMessage),
    action: SnackBarAction(
      label: label,
      onPressed: onPressed ?? () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackBar(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    action: SnackBarAction(
      label: 'Закрыть',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle googleFont(Color color, double size) {
  return GoogleFonts.montserrat(
    color: color,
    fontSize: size,
  );
}

Widget TextInputField(
    TextEditingController controller,
    String? initialValue,
    String? labelText,
    bool enabled,
    String Function(String?) validator,
    bool autoValidate,
    bool enableSuggestions,
    TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffix,
    double textfieldBorder,
    ThemeData themeData) {
  return TextFormField(
    controller: controller,
    initialValue: initialValue,
    enabled: enabled,
    validator: validator,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    autovalidateMode: AutovalidateMode.always,
    enableSuggestions: enableSuggestions,
    style: googleFont(
      enabled == true ? themeData.primaryColor : Colors.grey,
      16.0,
    ),
    cursorColor: themeData.secondaryHeaderColor,
    decoration: InputDecoration(
      suffixIcon: Padding(
        padding: EdgeInsets.only(
          right: suffix == null ? 0.0 : 15.0,
          left: suffix == null ? 0.0 : 15.0,
        ),
        child: suffix,
      ),
      labelText: labelText,
      labelStyle: googleFont(Colors.black, 14.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
      fillColor: Colors.white,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: textfieldBorder == 0.0 ? Colors.transparent : Colors.grey,
          width: textfieldBorder,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.green,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.green,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: themeData.primaryColor,
          width: 1.0,
        ),
      ),
    ),
  );
}

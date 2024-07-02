import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle textStyle = const TextStyle(
    fontFamily: 'Roboto Flex',
    fontWeight: FontWeight.w400,
    color: Color(0xFF3D2E5B),
    fontSize: 17,
  );
  static InputDecoration formStyle = InputDecoration(
    fillColor: const Color(0x3A1C102C),
    filled: true,
    hintStyle: textStyle.copyWith(
      fontSize: 20,
      color: const Color(0xB82B1A4E),
    ),
    floatingLabelStyle: textStyle.copyWith(
        fontSize: 20,
        color: const Color(0xB82B1A4E),
        height: 100
    ),
    contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 24
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(22),
    ),
  );
  static ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF2B1A4E)),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      textStyle: WidgetStateProperty.all<TextStyle>(textStyle.copyWith(
        fontSize: 19,
      )),
      padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))
  );

  Widget progressIndicator = const SizedBox(
    height: 22,
    width: 22,
    child: Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    ),
  );
}
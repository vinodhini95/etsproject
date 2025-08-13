import 'package:flutter/material.dart';

class AppStyles {
  Color defalutAppColor = Color(0xff285577);
  TextStyle appTextStyle = TextStyle(
      fontWeight: FontWeight.bold, color: Color(0xFFFF6600), fontSize: 24);

  static grtColor(int color) {
    return <int, Color>{
      50: Color(color),
      100: Color(color),
      200: Color(color),
      300: Color(color),
      400: Color(color),
      500: Color(color),
      600: Color(color),
      700: Color(color),
      800: Color(color),
      900: Color(color),
    };
  }
}
import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF10a125),
      onPrimary: Color(0xFF10a125),
      secondary: Color(0xFF395bf8),
      onSecondary: Color(0xFF395bf8),
      error: Colors.red,
      onError: Colors.red,
      background: Color(0xFF0c1216),
      onBackground: Color(0xFF0c1216),
      surface: Colors.white,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headline3: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headline4: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),
      headline5: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
    ),
  );
}

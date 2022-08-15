import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.white,
      onPrimary: Colors.white,
      secondary: Color(0xFF10a125),
      onSecondary: Color(0xFF10a125),
      error: Colors.red,
      onError: Colors.red,
      background: Color(0xFF0c1216),
      onBackground: Color(0xFF0c1216),
      surface: Colors.white,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(),
  );
}

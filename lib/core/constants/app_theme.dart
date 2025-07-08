import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() => ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6C63FF),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
      headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
      bodyText1: TextStyle(fontSize: 16, color: Colors.black87),
      bodyText2: TextStyle(fontSize: 14, color: Colors.black54),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFF6584)),
  );

  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF6C63FF),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF121212),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      bodyText1: TextStyle(fontSize: 16, color: Colors.white70),
      bodyText2: TextStyle(fontSize: 14, color: Colors.white54),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    ),
    colorScheme: ColorScheme.dark().copyWith(secondary: const Color(0xFFFF6584)),
  );
}
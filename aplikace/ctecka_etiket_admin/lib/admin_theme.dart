import 'package:flutter/material.dart';

class AdminTheme {
  static const Color primary = Color.fromRGBO(237, 221, 187, 0.5);
  static const Color secondary = Color(0xFFFF5722);
  static const Color scaffoldBg = Color(0xFFF5F1EB);
  static const Color sidebarBg = Color(0xFFE8DFD3);
  static const Color divider = Color(0xFFD0C4B3);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: scaffoldBg,
    primaryColor: primary,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
    ),
    dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    dividerColor: divider,
    iconTheme: const IconThemeData(color: Colors.black87),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.dark),
    scaffoldBackgroundColor: Colors.black,
    primaryColor: primary,
  );
}

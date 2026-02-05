import 'package:flutter/material.dart';

/// Central application theme and style tokens.
///
/// Adjust colors, radii, typography, and component themes here
/// to propagate consistent styling across the whole app.
class AppTheme {
  // Color tokens
  static const Color primary = Color(0xFF97C451);
  static const Color secondary = Color(0xFF009640);
  static const Color warning = Color(0xFFFF5722);
  static const Color scaffold = Color(0x4FEDDDBB);
  static const Color scaffoldAlt = Color(0x4FEDDDBB);
  static const Color surface = Color.fromRGBO(251, 247, 238, 1);
  static const Color closebutton = Color.fromRGBO(236, 104, 57, 1);
  static const Color firstbutton = Color.fromRGBO(201, 221, 159, 1);
  static const Color secondbutton = Color.fromRGBO(176, 209, 120, 1);
  static const Color black = Color(0xFF1A1C29);


  // Shape/spacing tokens
  static const double radius = 12.0;
  static const double largeRadius = 24.0;
  static const EdgeInsets pagePadding = EdgeInsets.all(24);

  // Typography
  static const String fontFamily = 'Snug Variable';

  /// Light theme configuration.
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surface,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: scaffold,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F1EB),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: const Color(0xFFF5F1EB),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withOpacity(0.9),
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: secondary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      dividerTheme: const DividerThemeData(space: 24, thickness: 1),
    );
  }
}

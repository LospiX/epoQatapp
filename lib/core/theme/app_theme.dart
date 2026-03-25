import 'package:flutter/material.dart';

/// App theme configuration with vibrant orange, black and deep purple color palette
class AppTheme {
  // Primary Colors
  static const Color primaryOrange = Color(0xFFFF7043); // More vibrant orange
  static const Color primaryBlack = Color(0xFF212121);  // Rich Black
  static const Color primaryPurple = Color(0xFF673AB7); // Deep Purple

  // Secondary Shades
  static const Color secondaryOrange = Color(0xFFFFAB91); // Light Orange
  static const Color secondaryBlack = Color(0xFF424242);  // Dark Grey
  static const Color secondaryPurple = Color(0xFF9575CD); // Light Purple

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFF3F0); // Very Light Orange Tint
  static const Color backgroundDark = Color(0xFF303030);  // Dark Grey

  // Text Colors
  static const Color textOnLight = Color(0xFF212121);  // Dark Text
  static const Color textOnDark = Color(0xFFF5F5F5);   // Light Text
  static const Color textMuted = Color(0xFF757575);    // Grey Text

  // Accent Colors for Feedback
  static const Color success = Color(0xFF4CAF50);  // Green
  static const Color error = Color(0xFFF44336);    // Red
  static const Color warning = Color(0xFFFF9800);  // Orange
  static const Color info = Color(0xFF2196F3);     // Blue

  /// Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryOrange,
      onPrimary: primaryBlack,
      secondary: primaryPurple,
      onSecondary: Colors.white,
      error: error,
      onError: Colors.white,
      background: backgroundLight,
      onBackground: textOnLight,
      surface: Colors.white,
      onSurface: textOnLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryOrange,
      foregroundColor: primaryBlack,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryBlack,
        backgroundColor: primaryOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryPurple,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryPurple,
        side: BorderSide(color: primaryPurple),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryPurple,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryPurple, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryPurple,
      unselectedItemColor: textMuted,
    ),
  );

  /// Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryOrange,
      onPrimary: primaryBlack,
      secondary: secondaryPurple,
      onSecondary: Colors.white,
      error: error,
      onError: Colors.white,
      background: backgroundDark,
      onBackground: textOnDark,
      surface: secondaryBlack,
      onSurface: textOnDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlack,
      foregroundColor: primaryOrange,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryBlack,
        backgroundColor: primaryOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: secondaryOrange,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: secondaryOrange,
        side: BorderSide(color: secondaryOrange),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryOrange,
      foregroundColor: primaryBlack,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color: secondaryBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryOrange, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryBlack,
      selectedItemColor: primaryOrange,
      unselectedItemColor: Colors.grey,
    ),
  );
}

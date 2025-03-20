import 'package:flutter/material.dart';

/// SnaplyTheme defines the application's comprehensive design system,
/// including colors, typography, shapes, and other visual elements.
class SnaplyTheme {
  // Private constructor to prevent instantiation
  SnaplyTheme._();

  // Color Palette
  static const Color _primaryLight = Color(0xFF6C63FF); // Refined purple accent
  static const Color _secondaryLight =
      Color(0xFF2ECBAA); // Teal accent for CTAs
  static const Color _tertiaryLight =
      Color(0xFFFF8A65); // Warm accent for highlights

  // Refined Neutrals
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _lightGray1 = Color(0xFFF8F9FA);
  static const Color _lightGray2 = Color(0xFFF1F3F5);
  static const Color _lightGray3 = Color(0xFFE9ECEF);
  static const Color _mediumGray = Color(0xFFADB5BD);
  static const Color _darkGray = Color(0xFF495057);
  static const Color _nearBlack = Color(0xFF212529);

  // Functional Colors
  static const Color _successLight = Color(0xFF40C057);
  static const Color _warningLight = Color(0xFFFFD43B);
  static const Color _errorLight = Color(0xFFFA5252);

  // Gradient Effects
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5A54D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Poppins',

    // Color Scheme
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _primaryLight,
      onPrimary: _white,
      secondary: _secondaryLight,
      onSecondary: _white,
      tertiary: _tertiaryLight,
      onTertiary: _white,
      error: _errorLight,
      onError: _white,
      background: _white,
      onBackground: _nearBlack,
      surface: _lightGray1,
      onSurface: _nearBlack,
      surfaceVariant: _lightGray2,
      onSurfaceVariant: _darkGray,
      outline: _mediumGray,
    ),

    // Typography
    textTheme: const TextTheme(
      // Display styles for hero sections and large titles
      displayLarge: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),

      // Heading styles for section headers
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),

      // Title styles for card titles and subtitles
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _darkGray,
        fontFamily: 'Poppins',
      ),

      // Body styles for primary content
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: _darkGray,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: _darkGray,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: _darkGray,
        fontFamily: 'Poppins',
      ),

      // Label styles for buttons and form elements
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: _darkGray,
        fontFamily: 'Poppins',
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: _white,
      foregroundColor: _nearBlack,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _nearBlack,
        fontFamily: 'Poppins',
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _primaryLight,
        foregroundColor: _white,
        minimumSize: const Size(0, 56),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontFamily: 'Poppins',
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryLight,
        minimumSize: const Size(0, 56),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _primaryLight, width: 1.5),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontFamily: 'Poppins',
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryLight,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontFamily: 'Poppins',
        ),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightGray2,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryLight, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _errorLight, width: 1.5),
      ),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: _darkGray,
        fontFamily: 'Poppins',
      ),
      hintStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: _mediumGray,
        fontFamily: 'Poppins',
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _white,
      selectedItemColor: _primaryLight,
      unselectedItemColor: _mediumGray,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: _white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: _lightGray3,
      thickness: 1,
      space: 1,
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _nearBlack,
      contentTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: _white,
        fontFamily: 'Poppins',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  // UI Spacing Constants
  static const double spaceXXS = 4.0;
  static const double spaceXS = 8.0;
  static const double spaceSM = 12.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Animation Durations
  static const Duration durationShort = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationLong = Duration(milliseconds: 500);

  // Shadow Styles
  static List<BoxShadow> get subtleShadow => [
        BoxShadow(
          color: _nearBlack.withOpacity(0.05),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get moderateShadow => [
        BoxShadow(
          color: _nearBlack.withOpacity(0.08),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get emphasizedShadow => [
        BoxShadow(
          color: _nearBlack.withOpacity(0.12),
          offset: const Offset(0, 8),
          blurRadius: 24,
          spreadRadius: 0,
        ),
      ];
}

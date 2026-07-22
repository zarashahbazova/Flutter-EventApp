import 'package:flutter/material.dart';

class AppTheme {
  //==================================================
  // TEMA RENK PALETİ (PURPLE THEME)
  //==================================================
  static const Color primaryColor = Color.fromARGB(245, 31, 2, 71); // Ana Mor Renk
  static const Color primaryDarkColor = Color.fromARGB(245, 23, 5, 49); // Koyu Mor
  static const Color accentColor = Color.fromARGB(255, 105, 20, 121); // Açık Vurgu Moru
  static const Color loginPageBG = Color.fromARGB(255, 91, 27, 98);
  // Nötr Renkler
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color error = Color(0xFFD32F2F);

  // Light Mod Renkleri
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Colors.white;
  static const Color lightSubtitle = Color(0xFF757575);

  // Dark Mod Renkleri
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E2C); // Hafif Morumsu Koyu Gri
  static const Color darkSubtitle = Color(0xFFB0BEC5);

  // Gri Tonları
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);

  //==================================================
  // FONT BOYUTLARI (TEXT SIZES)
  //==================================================
  static const double displayFont = 36;
  static const double titleFont = 25;
  static const double headingFont = 22;
  static const double bodyFont = 16;
  static const double subtitleFont = 14;
  static const double smallFont = 12;
  static const double buttonFont = 16;
  static const double inputFont = 15;

  //==================================================
  // FONT AĞIRLIKLARI (FONT WEIGHTS)
  //==================================================
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  //==================================================
  // BOYUTLAR & YARIÇAPLAR (RADII & SPACING)
  //==================================================
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXL = 32.0;

  static const double cardRadius = 20.0;
  static const double inputRadius = 16.0;

  static const double pagePadding = 20.0;
  static const double cardPadding = 16.0;
  static const double itemSpacing = 16.0;
  static const double buttonHeight = 52.0;

  static const double inputHorizontalPadding = 20.0;
  static const double inputVerticalPadding = 16.0;

  //==================================================
  // LIGHT THEME
  //==================================================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: lightSurface,
      error: error,
      onPrimary: white,
      onSecondary: white,
      onSurface: black,
    ),

    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: white,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(color: white),
    ),

    // Card
    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 2,
      shadowColor: primaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: displayFont,
        fontWeight: bold,
        color: primaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: titleFont,
        fontWeight: bold,
        color: black,
      ),
      titleLarge: TextStyle(
        fontSize: headingFont,
        fontWeight: semiBold,
        color: black,
      ),
      bodyLarge: TextStyle(
        fontSize: bodyFont,
        fontWeight: regular,
        color: black,
      ),
      bodyMedium: TextStyle(
        fontSize: subtitleFont,
        fontWeight: regular,
        color: lightSubtitle,
      ),
      bodySmall: TextStyle(
        fontSize: smallFont,
        fontWeight: regular,
        color: grey500,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryColor.withValues(alpha: 0.05),
      prefixIconColor: primaryColor,
      suffixIconColor: grey600,
      labelStyle: const TextStyle(
        color: primaryColor,
        fontSize: inputFont,
        fontWeight: medium,
      ),
      hintStyle: const TextStyle(color: grey500, fontSize: inputFont),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: inputHorizontalPadding,
        vertical: inputVerticalPadding,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide(
          color: primaryColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: const BorderSide(color: error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: const BorderSide(color: error, width: 2.0),
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: white,
        minimumSize: const Size(double.infinity, buttonHeight),
        elevation: 3,
        shadowColor: primaryColor.withValues(alpha: 0.4),
        textStyle: const TextStyle(fontSize: buttonFont, fontWeight: semiBold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(inputRadius),
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontSize: subtitleFont, fontWeight: bold),
      ),
    ),

    // Navigation Bar
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: lightSurface,
      indicatorColor: primaryColor.withValues(alpha: 0.15),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primaryColor, size: 26);
        }
        return const IconThemeData(color: grey600, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: primaryColor,
            fontSize: 12,
            fontWeight: semiBold,
          );
        }
        return const TextStyle(
          color: grey600,
          fontSize: 12,
          fontWeight: regular,
        );
      }),
    ),
  );

  //==================================================
  // DARK THEME
  //==================================================
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: darkSurface,
      error: error,
      onPrimary: white,
      onSecondary: white,
      onSurface: white,
    ),

    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: white,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(color: white),
    ),

    // Card
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: displayFont,
        fontWeight: bold,
        color: accentColor,
      ),
      headlineMedium: TextStyle(
        fontSize: titleFont,
        fontWeight: bold,
        color: white,
      ),
      titleLarge: TextStyle(
        fontSize: headingFont,
        fontWeight: semiBold,
        color: white,
      ),
      bodyLarge: TextStyle(
        fontSize: bodyFont,
        fontWeight: regular,
        color: white,
      ),
      bodyMedium: TextStyle(
        fontSize: subtitleFont,
        fontWeight: regular,
        color: darkSubtitle,
      ),
      bodySmall: TextStyle(
        fontSize: smallFont,
        fontWeight: regular,
        color: grey400,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      prefixIconColor: primaryColor,
      suffixIconColor: grey400,
      labelStyle: const TextStyle(
        color: primaryColor,
        fontSize: inputFont,
        fontWeight: medium,
      ),
      hintStyle: const TextStyle(color: grey500, fontSize: inputFont),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: inputHorizontalPadding,
        vertical: inputVerticalPadding,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: BorderSide(
          color: grey700.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: const BorderSide(color: accentColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: const BorderSide(color: error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputRadius),
        borderSide: const BorderSide(color: error, width: 2.0),
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: white,
        minimumSize: const Size(double.infinity, buttonHeight),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        textStyle: const TextStyle(fontSize: buttonFont, fontWeight: semiBold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(inputRadius),
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        textStyle: const TextStyle(fontSize: subtitleFont, fontWeight: bold),
      ),
    ),

    // Navigation Bar
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkSurface,
      indicatorColor: primaryColor.withValues(alpha: 0.3),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: accentColor, size: 26);
        }
        return const IconThemeData(color: grey400, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: accentColor,
            fontSize: 12,
            fontWeight: semiBold,
          );
        }
        return const TextStyle(
          color: grey400,
          fontSize: 12,
          fontWeight: regular,
        );
      }),
    ),
  );
}

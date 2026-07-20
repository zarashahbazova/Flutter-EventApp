import 'package:flutter/material.dart';

class AppTheme {


  //=========================
  // PRIMARY COLORS
  //=========================

  static const Color primaryColor = Color.fromARGB(255, 6, 63, 31); //login -> arkaplan, kayıt ol, kullanıcı adı kutusu borderları
  static const Color secondaryColor = Color.fromARGB(255, 32, 55, 17); // login imleç

  //=========================
  // BACKGROUND COLORS
  //=========================

  static const Color backgroundColor = Colors.white;

  static const Color cardColor = Colors.white;

  static const Color inputFillColor =
      Color.fromARGB(10, 9, 55, 45);

  //=========================
  // TEXT COLORS
  //=========================

  static const Color titleTextColor =
      Color(0xFF09372D);

  static const Color bodyTextColor =
      Color(0xFF09372D);

  static const Color subtitleTextColor =
      Color(0xFF6B6B6B);

  static const Color hintTextColor =
      Color(0xFF9E9E9E);

  //=========================
  // ICON COLORS
  //=========================

  static const Color primaryIconColor =
      Color(0xFF496860);

  static const Color secondaryIconColor =
      Color(0xFF9E9E9E);

  //=========================
  // BUTTON COLORS
  //=========================

  static const Color primaryButtonColor =
      Color(0xFF496860);

  static const Color secondaryButtonColor =
      Color(0xFFEAF6F2);

  static const Color buttonTextColor =
      Colors.white;

  //=========================
  // BORDER COLORS
  //=========================

  static const Color borderColor =
      Color.fromARGB(49, 9, 55, 66);

  //=========================
  // SHADOW COLORS
  //=========================

  static const Color shadowColor =
      Colors.black12;

  // ---------- LIGHT THEME ----------

  static final ThemeData lightTheme = ThemeData(

    useMaterial3: true,

      colorScheme: const ColorScheme.light(

        primary: primaryColor,

        secondary: secondaryColor,

        surface: cardColor,

        onPrimary: buttonTextColor,

        onSurface: titleTextColor,

      ),

    scaffoldBackgroundColor: backgroundColor,

      appBarTheme: const AppBarTheme(

      backgroundColor:
          primaryColor,

      foregroundColor:
          Colors.white,

      centerTitle: true,
      elevation: 2,

    ),

    textTheme: const TextTheme(

      headlineLarge: TextStyle(
        color: titleTextColor,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),

      headlineMedium: TextStyle(
        color: titleTextColor,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),

      bodyLarge: TextStyle(
        color: bodyTextColor,
        fontSize: 18,
      ),

      bodyMedium: TextStyle(
        color: subtitleTextColor,
        fontSize: 16,
      ),

      bodySmall: TextStyle(
        color: hintTextColor,
        fontSize: 14,
      ),

    ),

    inputDecorationTheme: InputDecorationTheme(

      filled: true,

      fillColor: inputFillColor,

      labelStyle: const TextStyle(
        color: titleTextColor,
      ),

      prefixIconColor: primaryIconColor,

      enabledBorder: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(25),

        borderSide: const BorderSide(
          color: borderColor,
          width: 2,
        ),
      ),

      focusedBorder: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(25),

        borderSide: const BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),

    ),

    elevatedButtonTheme:
    ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(
        
        backgroundColor:
            primaryButtonColor,

        foregroundColor:
            buttonTextColor,

      ),
 

    ),

    textButtonTheme:
    TextButtonThemeData(

      style: TextButton.styleFrom(

        foregroundColor:
            primaryColor,

      ),

    ),
    filledButtonTheme:
    FilledButtonThemeData(

      style: FilledButton.styleFrom(

        backgroundColor:
            primaryButtonColor,

        foregroundColor:
            buttonTextColor,

      ),

    ),

  );




  // ---------- DARK THEME ----------


static final ThemeData darkTheme = ThemeData(

    useMaterial3: true,

   colorScheme: const ColorScheme.dark(

    primary: Color(0xFF5F897E),

    secondary: Color(0xFF36544C),

    surface: Color(0xFF1E1E1E),

    onPrimary: Colors.white,

    onSurface: Colors.white,

  ),

    scaffoldBackgroundColor: const Color(0xFF121212),
  );
}
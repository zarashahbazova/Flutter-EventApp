// import 'package:flutter/material.dart';

// class AppTheme {
  
//   // PRIMARY COLORS
//   static const Color primaryColor = Color.fromRGBO(50, 35, 83, 1); //login -> arkaplan, kayıt ol, kullanıcı adı kutusu borderları
//   static const Color secondaryColor = Color.fromARGB(255, 246, 6, 6); // login imleç
//   static const Color firstColor = Color.fromARGB(150, 40, 50, 60);
//   static const Color accentColor = Colors.black;

//   // BACKGROUND COLORS
//   static const Color backgroundColor = Colors.white;
//   static const Color surfaceColor = Colors.white;
//   static const Color cardColor = Colors.white;
//   static const Color inputFillColor = Color.fromARGB(248, 121, 80, 174); //input kutularının dolgusu

//   // TEXT COLORS
//   static const Color titleTextColor = Color.fromARGB(255, 227, 5, 5); //giris yap yazısı kullanıcı adı yazısı sifre yazısı
//   static const Color bodyTextColor = Color(0xFF09372D);
//   static const Color subtitleTextColor = Color(0xFF6B6B6B);
//   static const Color hintTextColor = Color(0xFF9E9E9E);
//   static const Color errorTextColor = Colors.red;
//   static const Color iconTextColor = Color.fromARGB(255, 148, 103, 169);
  
//   // ICON COLORS
//   static const Color primaryIconColor = Color(0xFF496860);
//   static const Color secondaryIconColor = Color(0xFF9E9E9E);

//   // BUTTON COLORS
//   static const Color primaryButtonColor = Color(0xFF496860);
//   static const Color secondaryButtonColor = Color(0xFFEAF6F2);
//   static const Color buttonTextColor = Colors.white;

//   // BORDER COLORS
//   static const Color borderColor = Color.fromARGB(47, 99, 22, 138);
//   static const Color focusedBorderColor = Color.fromARGB(129, 99, 21, 135);
//   static const Color errorBorderColor = Colors.red;

//   // SHADOW COLORS
//   static const Color shadowColor = Colors.black12;

//   // font sizes
//   static const double inputFontSize = 15;
//   static const double otherFontSize = 14;
//   static const double displayFont = 36;
//   static const double titleFont = 30;
//   static const double headingFont = 40;
//   static const double bodyFont = 18;
//   static const double subtitleFont = 16;
//   static const double smallFont = 14;

//   //font weights
//   static const FontWeight light = FontWeight.w300;
//   static const FontWeight regular = FontWeight.w400;
//   static const FontWeight medium = FontWeight.w500;
//   static const FontWeight semiBold = FontWeight.w600;
//   static const FontWeight bold = FontWeight.w700;

//   //border radius
//   static const double smallRadius = 10;
//   static const double mediumRadius = 18;
//   static const double largeRadius = 25;
//   static const double extraRadius = 40;

//   //blur ve offset
//   static const double shadowBlur = 15;
//   static const Offset shadowOffset = Offset(0, 5);

//   //sizedbox yükseklik
//   static const double spaceSmall = 10;
//   static const double spaceMedium = 20;
//   static const double spaceLarge = 30;
//   static const double spaceXL = 40;
//   static const double loginTopSpace = 280;

//   //padding
//   static const double pagePadding = 24;

//   // ---------- LIGHT THEME ----------
//   static final ThemeData lightTheme = ThemeData(
//     useMaterial3: true,

//     colorScheme: const ColorScheme.light(
//       primary: primaryColor,
//       secondary: Color.fromARGB(255, 5, 75, 4),
//       surface: cardColor,
//       onPrimary: buttonTextColor,
//       onSurface: Color.fromARGB(255, 7, 69, 35),
//     ),

//     scaffoldBackgroundColor: backgroundColor,

//     appBarTheme: const AppBarTheme(
//       backgroundColor: primaryColor,

//       foregroundColor: Colors.white,

//       centerTitle: true,
//       elevation: 2,
//     ),

//     textTheme: const TextTheme(
//       displayLarge: TextStyle(
//         color: titleTextColor,
//         fontSize: inputFontSize,
//         fontWeight: light,
//       ),

//       headlineLarge: TextStyle(
//         fontSize: headingFont,
//         fontWeight: bold,
//         color: inputFillColor,
//       ),

//       headlineMedium: TextStyle(
//         fontSize: inputFontSize,
//         fontWeight: light,
//         color: titleTextColor,
//       ),

//       titleLarge: TextStyle(
//         fontSize: inputFontSize,
//         fontWeight: light,
//         color: bodyTextColor,
//       ),

//       bodyLarge: TextStyle(
//         fontSize: inputFontSize,
//         fontWeight: regular,
//         color: bodyTextColor,
//       ),

//       bodyMedium: TextStyle(
//         fontSize: inputFontSize,
//         fontWeight: regular,
//         color: subtitleTextColor,
//       ),

//       bodySmall: TextStyle(
//         fontSize: inputFontSize,
//         fontWeight: regular,
//         color: hintTextColor,
//       ),
//     ),

//     inputDecorationTheme: InputDecorationTheme(
//       filled: true, // dolgu

//       fillColor: const Color.fromARGB(30, 214, 186, 243), // dolgu rengi
//       contentPadding: const EdgeInsets.only(
//         left: 20,
//         top: 14,
//         right: 20,
//         bottom: 26,
//       ),

//       labelStyle: const TextStyle(
//         //yazi
//         color: iconTextColor,
//         fontSize: inputFontSize,
//         fontWeight: light,
//       ),

//       hintStyle: const TextStyle(color: hintTextColor, fontSize: inputFontSize),

//       prefixIconColor: iconTextColor,

//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(largeRadius),
//         borderSide: const BorderSide(color: borderColor, width: 2),
//       ),

//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(largeRadius),

//         borderSide: const BorderSide(color: focusedBorderColor, width: 2.5),
//       ),

//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(largeRadius),

//         borderSide: const BorderSide(color: focusedBorderColor, width: 2),
//       ),

//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(largeRadius),

//         borderSide: const BorderSide(color: errorBorderColor, width: 2.5),
//       ),
//     ),

//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         // Arka plan
//         backgroundColor: primaryColor,

//         // Yazı rengi
//         foregroundColor: buttonTextColor,

//         // Gölge
//         elevation: 6,
//         shadowColor: shadowColor,

//         // Buton boyutu
//         minimumSize: const Size(double.infinity, 55),

//         // İç boşluk
//         padding: const EdgeInsets.symmetric(
//           vertical: 16,
//           horizontal: 20,
//         ),

//         // Köşeler
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(largeRadius),
//         ),

//         // Kenarlık
//         side: const BorderSide(
//           color: borderColor,
//           width: 1,
//         ),

//         // Yazı stili
//         textStyle: const TextStyle(
//           fontSize: bodyFont,
//           fontWeight: bold,
//         ),
//       ),
//     ),

//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(foregroundColor: primaryColor),
//     ),
//     filledButtonTheme: FilledButtonThemeData(
//       style: FilledButton.styleFrom(
//         backgroundColor: primaryButtonColor,

//         foregroundColor: buttonTextColor,
//       ),
//     ),
//   );

//   // ---------- DARK THEME ----------
//   static final ThemeData darkTheme = ThemeData(
//     useMaterial3: true,

//     colorScheme: const ColorScheme.dark(
//       primary: Color.fromARGB(255, 137, 205, 187),

//       secondary: Color(0xFF36544C),

//       surface: Color(0xFF1E1E1E),

//       onPrimary: Colors.white,

//       onSurface: Colors.white,
//     ),

//     scaffoldBackgroundColor: const Color(0xFF121212),
//   );
// }


































// import 'package:flutter/material.dart';






// class AppTheme {

//   static const Color firstColor = Color.fromARGB(200, 40, 40, 58); // renk

//   static const double smallFont = 14; //font boyut

//   static const FontWeight light = FontWeight.w100; //font kalinlik

//   static const Offset shadowOffset = Offset(0,5); //offset


//   static final ThemeData lightTheme = ThemeData(
//     useMaterial3: true,

//     colorScheme: const ColorScheme.light(
//       primary: Color.fromARGB(150, 40, 50, 60),
//       secondary: Color.fromARGB(150, 40, 50, 60),
//       surface: Color.fromARGB(150, 40, 50, 60),
//       onPrimary: Color.fromARGB(150, 40, 50, 60),
//       onSurface:Color.fromARGB(150, 40, 50, 60),
//     ),

//     scaffoldBackgroundColor: Color.fromARGB(150, 40, 50, 60),,

//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color.fromARGB(150, 40, 50, 60),,

//       foregroundColor: Colors.white,

//       centerTitle: true,
//       elevation: 2,
//     ),

//     textTheme: const TextTheme(
//       displayLarge: TextStyle(
//         color: Color.fromARGB(150, 40, 50, 60),
//         fontSize: smallFont,
//         fontWeight: light,
//       ),

//       headlineLarge: TextStyle( 
//         fontSize: smallFont,
//         fontWeight: light,
//         color: Color.fromARGB(150, 40, 50, 60),
//       ),

//       headlineMedium: TextStyle(
//         fontSize: smallFont,
//         fontWeight: FontWeight.w100,
//         color: Color.fromARGB(150, 40, 50, 60),
//       ),

//       titleLarge: TextStyle(
//         fontSize: smallFont,
//         fontWeight: FontWeight.w100,
//         color: Color.fromARGB(150, 40, 50, 60),
//       ),

//       bodyLarge: TextStyle(
//         fontSize: smallFont,
//         fontWeight: FontWeight.w100,
//         color: Color.fromARGB(150, 40, 50, 60),
//       ),

//       bodyMedium: TextStyle(
//         fontSize: smallFont,
//         fontWeight: FontWeight.w100,
//         color: Color.fromARGB(150, 40, 50, 60),
//       ),

//       bodySmall: TextStyle(
//         fontSize: sm
//         fontWeight: Color.fromARGB(150, 40, 50, 60),,
//         color: Color.fromARGB(150, 40, 50, 60),,
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(

//       filled: true, // dolgu 

//       fillColor: const Color.fromARGB(30, 214, 186, 243), // dolgu rengi
//       contentPadding: const EdgeInsets.only(
//         left: 20,
//         top: 14,
//         right: 20,
//         bottom: 26,

//       ),

//       labelStyle: const TextStyle( //yazi
//         color: Color.fromARGB(150, 40, 50, 60),
//         fontSize: smallFont,
//         fontWeight: light,
//       ),

//       hintStyle: const TextStyle(
//         color: Color.fromARGB(150, 40, 50, 60),
//         fontSize: smallFont,
//       ),

//       prefixIconColor: Color.fromARGB(150, 40, 50, 60),

//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(
//           smallFont,
//         ),
//         borderSide: const BorderSide(
//           color: Color.fromARGB(150, 40, 50, 60),
//           width: 2,
//         ),

//       ),

//       focusedBorder: OutlineInputBorder(

//         borderRadius: BorderRadius.circular(

//           smallFont,

//         ),

//         borderSide: const BorderSide(

//           color: Color.fromARGB(150, 40, 50, 60),

//           width: 2.5,

//         ),

//       ),

//       errorBorder: OutlineInputBorder(

//         borderRadius: BorderRadius.circular(

//           smallFont,

//         ),

//         borderSide: const BorderSide(

//           color: Color.fromARGB(150, 40, 50, 60),

//           width: 2,

//         ),

//       ),

//       focusedErrorBorder: OutlineInputBorder(

//         borderRadius: BorderRadius.circular(

//           smallFont,

//         ),

//         borderSide: const BorderSide(

//           color: Color.fromARGB(150, 40, 50, 60),

//           width: 2.5,

//         ),

//       ),

//     ),

//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color.fromARGB(150, 40, 50, 60),

//         foregroundColor: Color.fromARGB(150, 40, 50, 60),
//       ),
//     ),

//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(foregroundColor: Color.fromARGB(150, 40, 50, 60),),
//     ),
//     filledButtonTheme: FilledButtonThemeData(
//       style: FilledButton.styleFrom(
//         backgroundColor: Color.fromARGB(150, 40, 50, 60),

//         foregroundColor: Color.fromARGB(150, 40, 50, 60),
//       ),
//     ),
//   );
  



  
// }
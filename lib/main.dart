import 'package:flutter/material.dart';
import 'package:staj_test1/pages/login_page.dart';
import 'package:staj_test1/pages/profile.dart';
import 'themes/app_theme.dart'; // Tema dosyanın yolu

// Global Tema Takipçisi
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // themeNotifier her değiştiğinde MaterialApp kendisini yeniden çizer
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          title: 'Staj Uygulaması',
          debugShowCheckedModeBanner: false,
          
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode, // Seçili temayı uygular

          home: const LoginPage(),
        );
      },
    );
  }
}
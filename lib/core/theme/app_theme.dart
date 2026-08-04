import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

 static ThemeData getTheme(Locale locale) {
    final bool isArabic = locale.languageCode == 'ar';

    return ThemeData(
      useMaterial3: true,

      // Background
      scaffoldBackgroundColor: Colors.white,

      // Font
      fontFamily: isArabic ? 'Cairo' : 'Inter',

      colorScheme: const ColorScheme.light(
        surface: Colors.white,
        primary: Colors.blue,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}

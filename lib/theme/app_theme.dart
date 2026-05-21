import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color red = Color(0xFFE60000);
  static const Color redDark = Color(0xFFB00000);
  static const Color redLight = Color(0xFFFF3333);
  static const Color black = Color(0xFF0A0A0A);
  static const Color darkBg = Color(0xFF111111);
  static const Color cardBg = Color(0xFF1A1A1A);
  static const Color cardBorder = Color(0xFF2A2A2A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF888888);
  static const Color greyLight = Color(0xFFCCCCCC);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: darkBg,
        colorScheme: const ColorScheme.dark(
          primary: red,
          secondary: redLight,
          surface: cardBg,
        ),
        textTheme: GoogleFonts.cairoTextTheme(
          const TextTheme(
            displayLarge: TextStyle(color: white),
            displayMedium: TextStyle(color: white),
            bodyLarge: TextStyle(color: white),
            bodyMedium: TextStyle(color: greyLight),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: darkBg,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.cairo(
            color: white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: white),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Цветовая палитра JigitWay
  static const Color backgroundDark = Color(0xFF101010); // Глубокий черный
  static const Color neonYellow = Color(0xFFEAB308); // Акцентный неоновый желтый
  static const Color surfaceDark = Color(0xFF1E1E1E); // Серый для карточек
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFFA0A0A0);

  // Основная тема
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: neonYellow,
      colorScheme: const ColorScheme.dark(
        primary: neonYellow,
        surface: surfaceDark,
        background: backgroundDark,
      ),
      // Шрифт стиля "Джигит" (брутальный, рубленный)
      textTheme: GoogleFonts.russoOneTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.russoOne(color: textWhite, fontSize: 32),
        bodyLarge: GoogleFonts.roboto(color: textWhite, fontSize: 16),
        bodyMedium: GoogleFonts.roboto(color: textGrey, fontSize: 14),
      ),
    );
  }
}

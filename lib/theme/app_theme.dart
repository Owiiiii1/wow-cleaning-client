import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Фирменные цвета WOW NOW CLEANING (Brand Book 2025).
class AppColors {
  AppColors._();

  /// Picton Blue — primary brand blue.
  static const Color pictonBlue = Color(0xFF37B7FF);

  /// Alias for existing code.
  static const Color blue = pictonBlue;

  /// Brand yellow accent.
  static const Color yellow = Color(0xFFFFDF59);

  /// Dark Liver — primary dark / text / icons.
  static const Color darkLiver = Color(0xFF4D4D4D);

  /// Alias for existing code.
  static const Color darkGray = darkLiver;

  /// Soft app background (brand surface).
  static const Color background = Color(0xFFFBF9F8);

  /// Warm off-white surface from login/design system.
  static const Color surface = Color(0xFFFBF9F8);

  static const Color white = Colors.white;

  /// Blue-tinted ambient shadow.
  static Color get glowShadow => pictonBlue.withValues(alpha: 0.08);
}

/// Типографика Brand Book: только Montserrat.
class AppFonts {
  AppFonts._();

  static const String family = 'Montserrat';

  static TextStyle montserrat({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  /// Заголовки: Bold / SemiBold, чаще UPPERCASE.
  static TextStyle headline({
    double fontSize = 20,
    Color color = AppColors.pictonBlue,
    FontWeight fontWeight = FontWeight.w700,
    double? letterSpacing,
  }) {
    return montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// Основной текст: Regular / Medium.
  static TextStyle body({
    double fontSize = 14,
    Color color = AppColors.darkLiver,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}

class AppTheme {
  static ThemeData get light {
    final baseText = GoogleFonts.montserratTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.pictonBlue,
        primary: AppColors.pictonBlue,
        secondary: AppColors.yellow,
        surface: AppColors.white,
        onSurface: AppColors.darkLiver,
      ),
      textTheme: baseText.apply(
        bodyColor: AppColors.darkLiver,
        displayColor: AppColors.darkLiver,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.darkLiver,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppFonts.headline(fontSize: 18),
      ),
    );
  }
}

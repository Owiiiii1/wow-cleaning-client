import 'package:flutter/material.dart';

/// Ручная настройка шапки Home.
class HeaderLayout {
  HeaderLayout._();

  /// Высота ряда шапки (без safe-area).
  static const double height = 64;

  /// Горизонтальные поля.
  static const double horizontalPadding = 20;

  /// Нижняя «нависающая» тень шапки (градиент — часть layout, не клипается).
  static const double shadowHeight = 10;
  static const Color shadowColor = Color(0x1A37B7FF); // Picton Blue ~10%

  /// Размер иконки меню (три полоски).
  static const double menuIconSize = 26;

  /// Зазор между меню и аватаром.
  static const double menuAvatarGap = 8;

  /// Диаметр аватара маскота.
  static const double avatarSize = 44;

  /// Зазор между аватаром и названием.
  static const double avatarTitleGap = 12;

  /// Размер текста WOW NOW.
  static const double titleFontSize = 20;

  /// Межбуквенный интервал названия.
  static const double titleLetterSpacing = 0.6;

  /// Размер иконки колокольчика.
  static const double bellIconSize = 26;
}

class HeaderAssets {
  HeaderAssets._();

  static const String mascot = 'asset/benjamin.png';
}

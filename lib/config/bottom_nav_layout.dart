import 'package:flutter/material.dart';

/// Панель нижней навигации: фон, отступы, ассеты, отладка.
///
/// Размеры и позиции кнопок — в [bottom_nav_buttons.dart].
class BottomNavLayout {
  BottomNavLayout._();

  /// Базовая высота панели (справочно). Рабочая высота — [BottomNavButtons.globalHeight].
  static const double panelHeight = 174;

  /// Горизонтальные поля панели от краёв экрана.
  static const double panelHorizontalInset = 0;

  /// Отступ панели от физического низа экрана (0 = впритык).
  static const double panelBottomGap = 0;

  // ── 3-slice фон (планшеты): центр фиксирован, края тянутся ─────────────
  /// Размер исходника `panelbig.png` (px).
  static const double panelSourceWidth = 1612;
  static const double panelSourceHeight = 664;

  /// Левая граница «центра» в исходнике (px) — начало го́рба.
  /// Всё левее тянется на широких экранах.
  static const double panelSourceCenterLeft = 520;

  /// Правая граница «центра» в исходнике (px) — конец го́рба.
  /// Всё правее тянется на широких экранах.
  static const double panelSourceCenterRight = 1092;

  /// Цвет заливки под системный навбар (тон низа панели).
  static const Color panelSafeAreaColor = Color(0xFFE9E9E9);

  /// Доп. подъём панели над системным низом = доля [panelHeight].
  /// Итоговый отступ снизу: safeArea + panelHeight * этот коэффициент.
  /// Высокая панель сама заполняет низ, поэтому подъём не нужен.
  static const double panelBottomLiftFactor = 0;

  /// Сколько нижних пикселей исходника тянем вниз под панель.
  /// Маленькое значение = кромка панели, продолженная без шва.
  static const double panelBottomEdgeSourcePx = 4;

  /// Горизонтальное размытие продолженной кромки — убирает вертикальные полосы
  /// от зерна исходника. 0 = без сглаживания.
  static const double panelBottomEdgeBlurSigma = 6;

  /// Нахлёст расширения на панель (px) — закрывает щель от округления пикселей.
  static const double panelBottomEdgeOverlap = 1.5;

  /// Сколько держать нажатый ассет центральной кнопки после клика.
  static const Duration centerButtonPressDuration = Duration(milliseconds: 500);

  /// Показать полупрозрачные рамки слотов для ручной подгонки.
  static const bool showSlotGuides = false;
}

/// Пути к ассетам нижней панели.
class BottomNavAssets {
  BottomNavAssets._();

  static const String panel = 'asset/panelbig.png';
  static const String centerButton = 'asset/button.png';
  static const String centerButtonPressed = 'asset/buttonON.png';
  static const String homeInactive = 'asset/home gray.png';
  static const String homeActive = 'asset/home blue2.png';
  static const String scheduleInactive = 'asset/schedule.png';
  static const String scheduleActive = 'asset/schedule blue.png';
  static const String chatInactive = 'asset/chat.png';
  static const String chatActive = 'asset/chat blue.png';
  static const String profileInactive = 'asset/profile.png';
  static const String profileActive = 'asset/profile blue.png';

  static const List<String> all = [
    panel,
    centerButton,
    centerButtonPressed,
    homeInactive,
    homeActive,
    scheduleInactive,
    scheduleActive,
    chatInactive,
    chatActive,
    profileInactive,
    profileActive,
  ];
}

/// Размеры и положение кнопок нижней панели.
///
/// - [globalHeight] — масштаб высоты всего блока (панель + кнопки)
/// - [globalOffsetY] — сдвиг всей конструкции вверх/вниз без искажений
/// - centerX — доля ширины панели (0.0 слева → 1.0 справа)
/// - offsetY — подъём от низа панели вверх (при [basePanelHeight])
/// - width / height — размер кнопки (при [basePanelHeight])
class BottomNavButtons {
  BottomNavButtons._();

  /// Базовая высота, под которую подобраны offset/size ниже.
  static const double basePanelHeight = 174;

  /// Глобальная высота всей нижней панели (панель + кнопки).
  /// Меньше [basePanelHeight] — всё ниже и компактнее; больше — выше.
  static const double globalHeight = 120;

  /// Масштаб от [globalHeight]. Все offset/size ниже умножаются на него.
  static double get heightScale => globalHeight / basePanelHeight;

  /// Сдвиг всей конструкции по вертикали (px), без масштаба.
  /// Больше 0 — вверх, меньше 0 — вниз.
  static const double globalOffsetY = -15;

  // ── Home ────────────────────────────────────────────────────────────────
  static const double homeCenterX = 0.125;
  static const double homeOffsetY = 48;
  static const double homeWidth = 80;
  static const double homeHeight = 80;

  // ── Schedule (2-я) ──────────────────────────────────────────────────────
  static const double scheduleCenterX = 0.300;
  static const double scheduleOffsetY = 44;
  static const double scheduleWidth = 90;
  static const double scheduleHeight = 90;

  // ── Chat (3-я) ──────────────────────────────────────────────────────────
  static const double chatCenterX = 0.7;
  static const double chatOffsetY = 57;
  static const double chatWidth = 55;
  static const double chatHeight = 55;

  // ── Profile (4-я) ───────────────────────────────────────────────────────
  static const double profileCenterX = 0.875;
  static const double profileOffsetY = 49;
  static const double profileWidth = 70;
  static const double profileHeight = 70;

  // ── Центральная кнопка (+) ──────────────────────────────────────────────
  static const double centerOffsetX = 0;
  static const double centerOffsetY = 86;
  static const double centerSize = 80;
}

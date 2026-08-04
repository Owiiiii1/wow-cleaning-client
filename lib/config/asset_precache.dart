import 'package:flutter/widgets.dart';
import 'package:wow_cleaning/config/bottom_nav_layout.dart';
import 'package:wow_cleaning/config/header_layout.dart';

/// Предзагрузка ассетов UI, чтобы не мигали при первом показе/нажатии.
class AssetPrecache {
  AssetPrecache._();

  static bool _started = false;

  static Future<void> warmUp(BuildContext context) async {
    if (_started) return;
    _started = true;

    final images = <String>[
      ...BottomNavAssets.all,
      HeaderAssets.mascot,
    ];

    await Future.wait([
      for (final path in images)
        precacheImage(AssetImage(path), context),
    ]);
  }
}

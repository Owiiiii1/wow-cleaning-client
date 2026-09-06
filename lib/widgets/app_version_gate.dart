import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wow_cleaning/config/app_config.dart';
import 'package:wow_cleaning/screens/force_update_screen.dart';
import 'package:wow_cleaning/services/version_check_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class AppVersionGate extends StatefulWidget {
  const AppVersionGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppVersionGate> createState() => _AppVersionGateState();
}

class _AppVersionGateState extends State<AppVersionGate> {
  final VersionCheckApi _api = VersionCheckApi();
  bool _ready = false;
  bool _blocked = false;
  String? _storeUrl;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version.trim().isEmpty
          ? AppConfig.appVersion
          : info.version.trim();
      final result = await _api.check(
        audience: 'client',
        platform: _platform(),
        version: version,
      );
      if (!mounted) return;
      setState(() {
        _blocked = !result.allowed || result.updateRequired;
        _storeUrl = result.storeUrl;
        _ready = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _blocked = false;
        _ready = true;
      });
    }
  }

  String _platform() {
    if (!kIsWeb && Platform.isIOS) return 'ios';
    return 'android';
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.pictonBlue),
        ),
      );
    }
    if (_blocked) {
      return ForceUpdateScreen(storeUrl: _storeUrl);
    }
    return widget.child;
  }
}

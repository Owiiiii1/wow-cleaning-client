import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow_cleaning/l10n/app_locales.dart';

class LocaleController extends ChangeNotifier {
  LocaleController._();

  static final LocaleController instance = LocaleController._();

  static const _prefsKey = 'app_locale';

  /// Default app language: English.
  static const Locale defaultLocale = AppLocales.english;

  Locale _locale = defaultLocale;

  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    // No saved choice → English. Never follow device locale.
    _locale = saved == null ? defaultLocale : AppLocales.fromCode(saved);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (AppLocales.codeOf(_locale) == AppLocales.codeOf(locale)) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, AppLocales.codeOf(locale));
  }
}

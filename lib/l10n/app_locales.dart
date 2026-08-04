import 'package:flutter/material.dart';

class AppLocales {
  AppLocales._();

  static const english = Locale('en');
  static const ukrainian = Locale('uk');
  static const spanishUs = Locale('es', 'US');
  static const russian = Locale('ru');

  /// English first = default language.
  static const supported = <Locale>[
    english,
    ukrainian,
    spanishUs,
    russian,
  ];

  static const Locale defaultLocale = english;

  static String codeOf(Locale locale) {
    if (locale.languageCode == 'es') return 'es_US';
    return locale.languageCode;
  }

  static Locale fromCode(String? code) {
    switch (code) {
      case 'uk':
        return ukrainian;
      case 'es':
      case 'es_US':
        return spanishUs;
      case 'ru':
        return russian;
      case 'en':
      default:
        return english;
    }
  }

  static String nativeName(Locale locale) {
    switch (codeOf(locale)) {
      case 'uk':
        return 'Українська';
      case 'es_US':
        return 'Español';
      case 'ru':
        return 'Русский';
      case 'en':
      default:
        return 'English';
    }
  }
}

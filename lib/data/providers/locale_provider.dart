import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  static const String _localeKey = 'selected_locale';

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('tr', 'TR'), // Turkish
    Locale('da', 'DK'), // Danish
  ];

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);

    if (localeCode != null) {
      final parts = localeCode.split('_');
      if (parts.length == 2) {
        state = Locale(parts[0], parts[1]);
      }
    }
    // If no saved locale, use system default (null)
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();

    if (locale != null) {
      await prefs.setString(_localeKey, '${locale.languageCode}_${locale.countryCode}');
    } else {
      await prefs.remove(_localeKey);
    }

    state = locale;
  }

  String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      case 'da':
        return 'Dansk';
      default:
        return locale.languageCode;
    }
  }

  String getCurrentLocaleName() {
    if (state == null) return 'System';
    return getLocaleName(state!);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});
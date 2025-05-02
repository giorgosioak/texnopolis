import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const _languageCodeKey = 'languageCode';
  Locale _locale = const Locale('el'); // default to Greek

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_languageCodeKey);
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  void setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    _locale = locale;
    await prefs.setString(_languageCodeKey, locale.languageCode);
    notifyListeners();
  }
}

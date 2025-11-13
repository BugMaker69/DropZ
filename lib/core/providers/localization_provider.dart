import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  late SharedPreferences _prefs;

  LocalizationProvider() {
    _loadLocale();
  }

  Locale get locale => _locale;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setLocale(Locale locale) {
    if (!['en', 'ar'].contains(locale.languageCode)) return;
    _locale = locale;
    _prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  void _loadLocale() async {
    await initPrefs();
    final savedLocale = _prefs.getString('locale');
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
      notifyListeners();
    }
  }
}

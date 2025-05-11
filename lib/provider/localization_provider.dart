import 'package:flutter/material.dart';
import 'package:intermediate_flutter/local/preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  final Preferences _preferences = Preferences();

  Locale _locale = const Locale("id");
  Locale get locale => _locale;

  LocalizationProvider() {
    initLocalLanguage();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    _preferences.setLocale(locale.languageCode);
    notifyListeners();
  }

  void initLocalLanguage() async {
    final locale = await _preferences.getLocale();
    _locale = Locale(locale);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends ChangeNotifier {
  static const String _languageKey = 'languageKey';

  String _language = 'en';  // Default

  String get language => _language;

  _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageValue = prefs.getString(_languageKey);

    // this sets language based on saved preference or default to English
    if (languageValue == 'am') {
      _language = 'am';  
    } else {
      _language = 'en'; 
    }
    notifyListeners();
  }

  // this sets language and save preference to SharedPreferences
  setLanguage(String lang) async {
    if (lang == 'en' || lang == 'am') {
      _language = lang;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, lang);
      notifyListeners();
    }
  }

  // used during initialization to load the language
  LanguageNotifier() {
    _loadLanguage();
  }
}

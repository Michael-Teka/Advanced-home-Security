import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends ChangeNotifier {
  static const String _lastLoginKey = 'lastLoginTime';
  static const String _tokenKey = 'token';
  bool isLoggedIn = false;
  bool isLoading = true;
  String? token;

  LoginNotifier() {
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginTime = prefs.getInt(_lastLoginKey);
    token = prefs.getString(_tokenKey);

    if (lastLoginTime != null && token != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if ((currentTime - lastLoginTime) <= 2304000000) {      //24h
        isLoggedIn = true;
      } else {
        await prefs.remove(_lastLoginKey);
        await prefs.remove(_tokenKey);
        isLoggedIn = false;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> login(String generatedToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_lastLoginKey, DateTime.now().millisecondsSinceEpoch);
    prefs.setString(_tokenKey, generatedToken);
    token = generatedToken;
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastLoginKey);
    await prefs.remove(_tokenKey);
    isLoggedIn = false;
    notifyListeners();
  }
}

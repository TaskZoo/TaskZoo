import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.light;

  ThemeMode get currentTheme => _currentTheme;

  void toggleTheme() {
    if (_currentTheme == ThemeMode.dark) {
      _currentTheme = ThemeMode.light;
    } else if (_currentTheme == ThemeMode.light) {
      _currentTheme = ThemeMode.dark;
    }
    notifyListeners();
  }

  bool isDarkTheme() => _currentTheme == ThemeMode.dark;
}

import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.dark;

  ThemeMode get currentTheme => _currentTheme;

  void toggleTheme() {
    if (_currentTheme == ThemeMode.dark) {
      _currentTheme = ThemeMode.light;
    } else {
      _currentTheme = ThemeMode.dark;
    }
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;
  late ThemeData _currentTheme;

  ThemeNotifier() {
    _currentTheme = lightTheme;
    _loadTheme();
  }

  ThemeData get currentTheme => _currentTheme;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    _currentTheme = isOn ? darkTheme : lightTheme;
    notifyListeners();
    _saveTheme(isOn);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }

  void _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _isDarkModeKey = 'isDarkMode';

  // Initialize SharedPreferences

  static Future<void> init() async {
    await SharedPreferences.getInstance();
  }

  // Get the current theme mode (default to light mode if not set)

  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false; // Default to light mode
  }

  // Set the theme mode

  static Future<void> setTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDarkMode);
  }
}

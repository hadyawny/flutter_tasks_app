import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _isDarkModeKey = 'isDarkMode';

  static Future<void> init() async {
    await SharedPreferences.getInstance();
    // Ensure preferences are loaded before accessing them
  }

  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false; // Default to light mode
  }

  static Future<void> setTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDarkMode);
  }
}

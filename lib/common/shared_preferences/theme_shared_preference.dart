import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  static Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }
}

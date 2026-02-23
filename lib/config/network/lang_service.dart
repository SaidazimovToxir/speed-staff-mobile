import 'package:shared_preferences/shared_preferences.dart';

class LangService {
  static const String _keyLanguageCode = "language_code";

  /// Saves the language code in SharedPreferences
  static Future<void> setLanguageCode(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguageCode, languageCode);
  }

  /// Retrieves the saved language code from SharedPreferences
  /// Returns a default language code (e.g., 'en') if not set
  static Future<String> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguageCode) ?? "ru";
  }
}

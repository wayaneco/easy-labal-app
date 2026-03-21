import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  static Future<void> setString(String key, String value) async {
    final prefs = await _prefs;

    prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await _prefs;

    return prefs.getString(key);
  }

  static Future<void> clear() async {
    final prefs = await _prefs;

    prefs.clear();
  }
}

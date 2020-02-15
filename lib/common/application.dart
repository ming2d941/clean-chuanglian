import 'package:shared_preferences/shared_preferences.dart';

class Application{
  static Preference perference;
}

class Preference {
  static const String KEY_ADMIN_NAME = '';
  static const String KEY_ADMIN_PATH = '';
  static String workerSignPath;

  static setAdminName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_ADMIN_NAME, name);
  }

  static getAdminName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_ADMIN_NAME);
  }

  static setAdminSignPath(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_ADMIN_PATH, name);
  }

  static Future<String> getAdminSignPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_ADMIN_PATH);
  }
}
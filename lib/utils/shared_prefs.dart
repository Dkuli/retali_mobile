// lib/utils/shared_prefs.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefs {
  static late SharedPreferences _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString('user', json.encode(user));
  }

  static Map<String, dynamic>? getUser() {
    final userStr = _prefs.getString('user');
    if (userStr == null) return null;
    return json.decode(userStr);
  }

  static Future<void> clearUser() async {
    await _prefs.remove('user');
  }

  // Token
  static Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);
  }

  static String? getToken() {
    return _prefs.getString('token');
  }

  static Future<void> clearToken() async {
    await _prefs.remove('token');
  }

  // FCM Token
  static Future<void> saveFcmToken(String token) async {
    await _prefs.setString('fcm_token', token);
  }

  static String? getFcmToken() {
    return _prefs.getString('fcm_token');
  }

  // Settings
  static Future<void> saveThemeMode(String mode) async {
    await _prefs.setString('theme_mode', mode);
  }

  static String getThemeMode() {
    return _prefs.getString('theme_mode') ?? 'system';
  }

  static Future<void> saveLanguage(String language) async {
    await _prefs.setString('language', language);
  }

  static String getLanguage() {
    return _prefs.getString('language') ?? 'id';
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}

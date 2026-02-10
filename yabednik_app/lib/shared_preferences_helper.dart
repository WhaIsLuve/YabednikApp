import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_session.dart';

class SharedPreferencesHelper {
  static const _keySession = 'user_session';

  static Future<void> saveSession(UserSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySession, jsonEncode(session.toJson()));
  }

  static Future<UserSession?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keySession);
    if (jsonString != null) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserSession.fromJson(json);
    }
    return null;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySession);
  }
}
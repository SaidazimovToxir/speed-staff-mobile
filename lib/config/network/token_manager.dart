import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/di/injection_container.dart';

class TokenManager {
  //!token-----------------------------------
  final String _tokenKey = 'auth_key';
  final prefs = sl.get<SharedPreferences>();

  /// Tokenni saqlash
  Future<void> saveToken(String token) async {
    await prefs.setString(_tokenKey, token);
  }

  /// Tokenni olish
  String? getToken() {
    return prefs.getString(_tokenKey);
  }

  /// Tokenni o'chirish
  Future<void> deleteToken() async {
    await prefs.remove(_tokenKey);
  }
}

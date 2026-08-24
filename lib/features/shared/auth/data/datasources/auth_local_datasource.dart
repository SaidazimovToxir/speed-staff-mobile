import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_staff_mobile/config/core/error/exceptions.dart';
import 'package:speed_staff_mobile/features/shared/auth/data/models/user_model.dart';

/// Interface for local data storage operations related to authentication
abstract class AuthLocalDataSource {
  /// Retrieves the last cached user
  /// Throws [CacheException] if no user is found
  Future<UserModel?> getLastUser();

  /// Caches the user data
  /// Throws [CacheException] if caching fails
  Future<void> cacheUser(UserModel user);

  /// Caches the authentication token
  /// Throws [CacheException] if caching fails
  Future<void> cacheToken(String token);

  /// Retrieves the cached authentication token
  /// Throws [CacheException] if no token is found
  Future<String?> getToken();

  /// Caches the refresh token
  Future<void> cacheRefreshToken(String token);

  /// Retrieves the cached refresh token
  Future<String?> getRefreshToken();

  /// Clears all cached authentication data
  /// Throws [CacheException] if clearing fails
  Future<void> clearAuthData();
}

/// Implementation of [AuthLocalDataSource] using SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String userKey = 'CACHED_USER';
  static const String tokenKey = 'AUTH_TOKEN';
  static const String refreshTokenKey = 'REFRESH_TOKEN';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<UserModel?> getLastUser() async {
    try {
      final jsonString = sharedPreferences.getString(userKey);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await sharedPreferences.setString(userKey, json.encode(user.toJson()));
    } catch (e) {
      throw CacheException('${'failed_to_cache_user'.tr()}: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await sharedPreferences.setString(tokenKey, token);
    } catch (e) {
      throw CacheException('${'failed_to_cache_token'.tr()}: ${e.toString()}');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(tokenKey);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheRefreshToken(String token) async {
    try {
      await sharedPreferences.setString(refreshTokenKey, token);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return sharedPreferences.getString(refreshTokenKey);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await sharedPreferences.remove(userKey);
      await sharedPreferences.remove(tokenKey);
      await sharedPreferences.remove(refreshTokenKey);
    } catch (e) {
      throw CacheException('${'failed_to_clear_auth_data'.tr()}: ${e.toString()}');
    }
  }
}

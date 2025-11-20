import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/entities/user.dart';

class AuthStorage {
  AuthStorage._(this._prefs);

  final SharedPreferences _prefs;

  static Future<AuthStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthStorage._(prefs);
  }

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  static const _deviceFcmTokenKey = 'device_fcm_token';
  static const _backendFcmTokenKey = 'backend_fcm_token';

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  Future<void> saveUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    final value = _prefs.getString(_userKey);
    if (value == null) {
      return null;
    }
    try {
      final Map<String, dynamic> json = jsonDecode(value) as Map<String, dynamic>;
      return User.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }

  Future<void> clear() async {
    await Future.wait([
      clearToken(),
      clearUser(),
      clearDeviceFcmToken(),
      clearBackendFcmToken(),
    ]);
  }

  Future<void> saveDeviceFcmToken(String token) async {
    await _prefs.setString(_deviceFcmTokenKey, token);
  }

  Future<String?> getDeviceFcmToken() async {
    return _prefs.getString(_deviceFcmTokenKey);
  }

  Future<void> clearDeviceFcmToken() async {
    await _prefs.remove(_deviceFcmTokenKey);
  }

  Future<void> saveBackendFcmToken(String token) async {
    await _prefs.setString(_backendFcmTokenKey, token);
  }

  Future<String?> getBackendFcmToken() async {
    return _prefs.getString(_backendFcmTokenKey);
  }

  Future<void> clearBackendFcmToken() async {
    await _prefs.remove(_backendFcmTokenKey);
  }
}

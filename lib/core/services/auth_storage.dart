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
  static const _userIdKey = 'auth_user_id';
  static const _userPhoneKey = 'auth_user_phone';
  static const _profileCompletedKey = 'auth_profile_completed';

  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getAuthToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearAuthToken() async {
    await _prefs.remove(_tokenKey);
  }

  Future<void> saveUserId(int id) async {
    await _prefs.setInt(_userIdKey, id);
  }

  Future<int?> getUserId() async {
    return _prefs.getInt(_userIdKey);
  }

  Future<void> clearUserId() async {
    await _prefs.remove(_userIdKey);
  }

  Future<void> saveUserPhone(String phone) async {
    await _prefs.setString(_userPhoneKey, phone);
  }

  Future<String?> getUserPhone() async {
    return _prefs.getString(_userPhoneKey);
  }

  Future<void> clearUserPhone() async {
    await _prefs.remove(_userPhoneKey);
  }

  Future<void> saveProfileCompleted(bool value) async {
    await _prefs.setBool(_profileCompletedKey, value);
  }

  Future<bool?> getProfileCompleted() async {
    return _prefs.getBool(_profileCompletedKey);
  }

  Future<void> clearProfileCompleted() async {
    await _prefs.remove(_profileCompletedKey);
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
      clearAuthToken(),
      clearUser(),
      clearUserId(),
      clearUserPhone(),
      clearProfileCompleted(),
    ]);
  }
}

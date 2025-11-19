import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_enums.dart';

class LocalStorageService {
  LocalStorageService._(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService._(prefs);
  }

  static const _onboardingKey = 'onboarding_completed';
  static const _authStatusKey = 'auth_status';
  static const _themeModeKey = 'theme_mode';
  static const _localeKey = 'locale';
  static const _notificationPromptDismissedKey = 'notification_prompt_dismissed';

  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(_onboardingKey, value);
  }

  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setAuthStatus(AuthStatus status) async {
    await _prefs.setString(_authStatusKey, status.name);
  }

  Future<AuthStatus> getAuthStatus() async {
    final value = _prefs.getString(_authStatusKey);
    switch (value) {
      case 'authenticated':
        return AuthStatus.authenticated;
      case 'guest':
        return AuthStatus.guest;
      case 'loggedOut':
        return AuthStatus.loggedOut;
      default:
        return AuthStatus.loggedOut;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.name);
  }

  Future<ThemeMode> getThemeMode() async {
    final value = _prefs.getString(_themeModeKey);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  Future<Locale> getLocale() async {
    final value = _prefs.getString(_localeKey);
    if (value == 'ar') {
      return const Locale('ar');
    }
    return const Locale('en');
  }

  Future<void> clearAuth() async {
    await _prefs.remove(_authStatusKey);
  }

  Future<void> setNotificationPromptDismissed(bool value) async {
    await _prefs.setBool(_notificationPromptDismissedKey, value);
  }

  Future<bool> hasDismissedNotificationPrompt() async {
    return _prefs.getBool(_notificationPromptDismissedKey) ?? false;
  }
}

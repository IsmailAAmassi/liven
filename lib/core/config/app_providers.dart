import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/local_storage_service.dart';
import '../services/fake_auth_service.dart';
import 'app_enums.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('LocalStorageService not initialized');
});

final fakeAuthServiceProvider = Provider<FakeAuthService>((ref) {
  return FakeAuthService();
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return ThemeModeNotifier(storage);
});

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return LocaleNotifier(storage);
});

final authStatusProvider = StateNotifierProvider<AuthStatusNotifier, AuthStatus>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return AuthStatusNotifier(storage);
});

final onboardingCompletedProvider =
    StateNotifierProvider<OnboardingStatusNotifier, bool>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return OnboardingStatusNotifier(storage);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._storage) : super(ThemeMode.system) {
    _load();
  }

  final LocalStorageService _storage;
  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> _load() async {
    state = await _storage.getThemeMode();
    _initialized = true;
  }

  Future<void> toggleTheme() async {
    final next = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(next);
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await _storage.setThemeMode(mode);
  }
}

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._storage) : super(const Locale('en')) {
    _load();
  }

  final LocalStorageService _storage;
  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> _load() async {
    state = await _storage.getLocale();
    _initialized = true;
  }

  Future<void> toggleLocale() async {
    final next = state.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    state = next;
    await _storage.setLocale(next);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _storage.setLocale(locale);
  }
}

class AuthStatusNotifier extends StateNotifier<AuthStatus> {
  AuthStatusNotifier(this._storage) : super(AuthStatus.unknown) {
    _load();
  }

  final LocalStorageService _storage;
  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> _load() async {
    final stored = await _storage.getAuthStatus();
    state = stored;
    _initialized = true;
  }

  Future<void> setStatus(AuthStatus status) async {
    state = status;
    await _storage.setAuthStatus(status);
  }
}

class OnboardingStatusNotifier extends StateNotifier<bool> {
  OnboardingStatusNotifier(this._storage) : super(false) {
    _load();
  }

  final LocalStorageService _storage;
  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> _load() async {
    state = await _storage.isOnboardingCompleted();
    _initialized = true;
  }

  Future<void> markCompleted() async {
    state = true;
    await _storage.setOnboardingCompleted(true);
  }

  Future<void> reset() async {
    state = false;
    await _storage.setOnboardingCompleted(false);
  }
}

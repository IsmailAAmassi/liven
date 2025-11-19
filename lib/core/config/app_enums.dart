import 'package:flutter/material.dart';

import 'package:liven/l10n/app_localizations.dart';

enum AuthStatus {
  unknown,
  authenticated,
  guest,
  loggedOut,
}

enum AppLanguage { english, arabic }

extension AppLanguageX on AppLanguage {
  Locale get locale => switch (this) {
        AppLanguage.english => const Locale('en'),
        AppLanguage.arabic => const Locale('ar'),
      };

  String get flag => switch (this) {
        AppLanguage.english => '🇺🇸',
        AppLanguage.arabic => '🇸🇦',
      };

  String label(AppLocalizations l10n) => switch (this) {
        AppLanguage.english => l10n.languageEnglish,
        AppLanguage.arabic => l10n.languageArabic,
      };

  static AppLanguage fromLocale(Locale locale) =>
      locale.languageCode == 'ar' ? AppLanguage.arabic : AppLanguage.english;
}

enum ThemePreference { system, light, dark }

extension ThemePreferenceX on ThemePreference {
  ThemeMode get mode => switch (this) {
        ThemePreference.system => ThemeMode.system,
        ThemePreference.light => ThemeMode.light,
        ThemePreference.dark => ThemeMode.dark,
      };

  IconData get icon => switch (this) {
        ThemePreference.system => Icons.brightness_auto,
        ThemePreference.light => Icons.light_mode,
        ThemePreference.dark => Icons.dark_mode,
      };

  String label(AppLocalizations l10n) => switch (this) {
        ThemePreference.system => l10n.themeSystem,
        ThemePreference.light => l10n.themeLight,
        ThemePreference.dark => l10n.themeDark,
      };

  String description(AppLocalizations l10n) => switch (this) {
        ThemePreference.system => l10n.themeSystemDescription,
        ThemePreference.light => l10n.themeLightDescription,
        ThemePreference.dark => l10n.themeDarkDescription,
      };

  static ThemePreference fromThemeMode(ThemeMode mode) => switch (mode) {
        ThemeMode.light => ThemePreference.light,
        ThemeMode.dark => ThemePreference.dark,
        ThemeMode.system => ThemePreference.system,
      };
}

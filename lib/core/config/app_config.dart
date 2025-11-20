class AppConfig {
  AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'APP_BASE_URL',
    defaultValue: 'https://liven-sa.com/api',
  );

  static const String webAppUrl = String.fromEnvironment(
    'APP_WEB_APP_URL',
    defaultValue: 'https://app.liven-sa.com/',
  );

  static final bool useFakeAuth = _parseBool(
    const String.fromEnvironment('USE_FAKE_AUTH', defaultValue: 'true'),
  );

  static final bool useFakeSettings = _parseBool(
    const String.fromEnvironment('USE_FAKE_SETTINGS', defaultValue: 'false'),
  );

  static final bool completeProfileRequired = _parseBool(
    const String.fromEnvironment('COMPLETE_PROFILE_REQUIRED', defaultValue: 'false'),
  );

  static final int completeProfileReminderIntervalMinutes = _parseInt(
    const String.fromEnvironment('COMPLETE_PROFILE_REMINDER_INTERVAL_MINUTES',
        defaultValue: '1440'),
  );

  static bool _parseBool(String value) {
    final normalized = value.toLowerCase().trim();
    if (normalized == 'true' || normalized == '1') {
      return true;
    }
    if (normalized == 'false' || normalized == '0') {
      return false;
    }
    return true;
  }

  static int _parseInt(String value) {
    return int.tryParse(value.trim()) ?? 0;
  }
}

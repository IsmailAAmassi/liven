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
    const String.fromEnvironment('USE_FAKE_AUTH', defaultValue: 'false'),
  );

  static final bool useFakeSettings = _parseBool(
    const String.fromEnvironment('USE_FAKE_SETTINGS', defaultValue: 'false'),
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
}

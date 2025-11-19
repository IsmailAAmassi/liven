class AppConfig {
  AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'APP_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static final bool useFakeAuth = _parseBool(
    const String.fromEnvironment('USE_FAKE_AUTH', defaultValue: 'true'),
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

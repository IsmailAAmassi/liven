class SettingsData {
  const SettingsData({
    required this.baseUrl,
    required this.appUrl,
    required this.paths,
  });

  final String baseUrl;
  final String appUrl;
  final SettingsPaths paths;

  factory SettingsData.fromJson(Map<String, dynamic> json) {
    final baseUrl = json['base_url'] as String? ?? '';
    final appUrl = json['app_url'] as String? ?? '';
    return SettingsData(
      baseUrl: baseUrl,
      appUrl: appUrl,
      paths: SettingsPaths.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_url': baseUrl,
      'app_url': appUrl,
      ...paths.toJson(),
    };
  }

  SettingsData copyWith({
    String? baseUrl,
    String? appUrl,
    SettingsPaths? paths,
  }) {
    return SettingsData(
      baseUrl: baseUrl ?? this.baseUrl,
      appUrl: appUrl ?? this.appUrl,
      paths: paths ?? this.paths,
    );
  }
}

class SettingsPaths {
  const SettingsPaths({
    required this.ticketsPath,
    required this.profilePath,
    required this.homePath,
    required this.foodPlanPath,
    required this.weightStatisticsPath,
  });

  final String ticketsPath;
  final String profilePath;
  final String homePath;
  final String foodPlanPath;
  final String weightStatisticsPath;

  factory SettingsPaths.fromJson(Map<String, dynamic> json) {
    return SettingsPaths(
      ticketsPath: _readPath(json, 'tickets'),
      profilePath: _readPath(json, 'profile'),
      homePath: _readPath(json, 'home'),
      foodPlanPath: _readPath(json, 'food_plan', aliases: const ['food-plan']),
      weightStatisticsPath: _readPath(
        json,
        'weight_statistics',
        aliases: const ['weight-statistics'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tickets': ticketsPath,
      'profile': profilePath,
      'home': homePath,
      'food_plan': foodPlanPath,
      'weight_statistics': weightStatisticsPath,
    };
  }
}

String _readPath(
  Map<String, dynamic> source,
  String key, {
  List<String> aliases = const [],
}) {
  final candidates = <String>[key, ...aliases];
  for (final candidate in candidates) {
    final value = source[candidate];
    if (value is String && value.isNotEmpty) {
      return value;
    }
  }
  return '';
}

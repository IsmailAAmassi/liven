import '../../../core/config/app_config.dart';
import '../../auth/domain/entities/user.dart';
import '../../settings/domain/models/settings_data.dart';

Uri buildHomeWebUri(SettingsData settings, User? user) {
  final baseUrl = _resolveContentBase(settings);
  final queryParameters = _userIdParams(user);
  return _buildWebUri(
    baseUrl: baseUrl,
    queryParameters: queryParameters.isEmpty ? null : queryParameters,
  );
}

Uri buildDailyRecordsWebUri(SettingsData settings) {
  final baseUrl = _resolveContentBase(settings);
  final path = settings.paths.foodPlanPath.isNotEmpty
      ? settings.paths.foodPlanPath
      : '/food-plan';

  return _buildWebUri(baseUrl: baseUrl, path: path);
}

Uri buildStatisticsWebUri(SettingsData settings) {
  final baseUrl = _resolveContentBase(settings);
  final path = settings.paths.weightStatisticsPath.isNotEmpty
      ? settings.paths.weightStatisticsPath
      : '/weight-statistics';

  return _buildWebUri(baseUrl: baseUrl, path: path);
}

String _resolveContentBase(SettingsData settings) {
  if (settings.appUrl.isNotEmpty) {
    return settings.appUrl;
  }
  if (settings.baseUrl.isNotEmpty) {
    return settings.baseUrl;
  }
  return AppConfig.webAppUrl;
}

Map<String, String> _userIdParams(User? user) {
  if (user == null || user.id.isEmpty) {
    // Guest user id
    return const {'user_id': '16'};
  }
  return {'user_id': user.id};
}

Uri _buildWebUri({
  required String baseUrl,
  String? path,
  Map<String, String>? queryParameters,
}) {
  final baseUri = Uri.parse(baseUrl);
  final resolvedUri = path != null && path.isNotEmpty
      ? baseUri.resolve(path)
      : baseUri;

  final normalizedUri = resolvedUri.path.isEmpty
      ? resolvedUri.replace(path: '/')
      : resolvedUri;
  final mergedQuery = {
    ...normalizedUri.queryParameters,
    if (queryParameters != null) ...queryParameters,
  };

  return normalizedUri.replace(
    queryParameters: mergedQuery.isEmpty ? null : mergedQuery,
  );
}

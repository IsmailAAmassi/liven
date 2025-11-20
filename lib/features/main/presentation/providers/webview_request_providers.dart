import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/app_providers.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../settings/domain/models/settings_data.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

class TabWebRequest {
  const TabWebRequest({required this.uri, this.headers = const {}});

  final Uri uri;
  final Map<String, String> headers;
}

final homeWebRequestProvider = FutureProvider<TabWebRequest>((ref) async {
  // Rebuild when auth state changes so the user id is kept in sync.
  ref.watch(authStatusProvider);
  final settings = await ref.watch(settingsFutureProvider.future);
  final authRepository = ref.watch(authRepositoryProvider);
  final user = await authRepository.getCurrentUser();

  final baseUrl = settings.appUrl.isNotEmpty
      ? settings.appUrl
      : (settings.baseUrl.isNotEmpty ? settings.baseUrl : AppConfig.webAppUrl);

  final queryParameters = _userIdParams(user);
  final uri = _buildWebUri(
    baseUrl: baseUrl,
    queryParameters: queryParameters.isEmpty ? null : queryParameters,
  );

  return TabWebRequest(uri: uri);
});

final dailyRecordsWebRequestProvider =
    FutureProvider<TabWebRequest>((ref) async {
  final settings = await ref.watch(settingsFutureProvider.future);
  final baseUrl = _resolveContentBase(settings);
  final path = settings.paths.foodPlanPath.isNotEmpty
      ? settings.paths.foodPlanPath
      : '/food-plan';

  final uri = _buildWebUri(baseUrl: baseUrl, path: path);
  return TabWebRequest(uri: uri);
});

final statisticsWebRequestProvider = FutureProvider<TabWebRequest>((ref) async {
  final settings = await ref.watch(settingsFutureProvider.future);
  final baseUrl = _resolveContentBase(settings);
  final path = settings.paths.weightStatisticsPath.isNotEmpty
      ? settings.paths.weightStatisticsPath
      : '/weight-statistics';

  final uri = _buildWebUri(baseUrl: baseUrl, path: path);
  return TabWebRequest(uri: uri);
});

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
    return const {};
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
  final mergedQuery = {
    ...resolvedUri.queryParameters,
    if (queryParameters != null) ...queryParameters,
  };

  return resolvedUri.replace(
    queryParameters: mergedQuery.isEmpty ? null : mergedQuery,
  );
}

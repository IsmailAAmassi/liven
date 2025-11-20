import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/data/auth_repository.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/webview_url_builder.dart';
import '../../../../core/config/app_providers.dart';

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

  final uri = buildHomeWebUri(settings, user);
  return TabWebRequest(uri: uri);
});

final dailyRecordsWebRequestProvider =
    FutureProvider<TabWebRequest>((ref) async {
  final settings = await ref.watch(settingsFutureProvider.future);
  final uri = buildDailyRecordsWebUri(settings);
  return TabWebRequest(uri: uri);
});

final statisticsWebRequestProvider = FutureProvider<TabWebRequest>((ref) async {
  final settings = await ref.watch(settingsFutureProvider.future);
  final uri = buildStatisticsWebUri(settings);
  return TabWebRequest(uri: uri);
});

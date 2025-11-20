import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/app_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

class HomeWebRequest {
  const HomeWebRequest({required this.uri, this.headers = const {}});

  final Uri uri;
  final Map<String, String> headers;
}

final homeWebRequestProvider = FutureProvider<HomeWebRequest>((ref) async {
  // Rebuild when the auth status changes to refresh the injected token.
  ref.watch(authStatusProvider);
  final settings = ref.watch(settingsFutureProvider);
  final storage = ref.watch(authStorageProvider);
  final token = await storage.getToken();
  final baseUrl = settings.maybeWhen(
    data: (data) => data.appUrl.isNotEmpty ? data.appUrl : AppConfig.homeWebUrl,
    orElse: () => AppConfig.homeWebUrl,
  );
  return _buildRequestWithToken(baseUrl, token: token);
});

HomeWebRequest _buildRequestWithToken(String baseUrl, {String? token}) {
  final uri = _buildUrlWithToken(baseUrl, token: token);
  // Token strategy lives here so we can easily switch between query parameters,
  // custom headers, or postMessage bridges without touching the UI layer.
  const headers = <String, String>{};
  return HomeWebRequest(uri: uri, headers: headers);
}

Uri _buildUrlWithToken(String baseUrl, {String? token}) {
  final uri = Uri.parse(baseUrl);
  if (token == null || token.isEmpty) {
    return uri;
  }

  final queryParameters = Map<String, String>.from(uri.queryParameters);
  return uri.replace(
    queryParameters: {
      ...queryParameters,
      'token': token,
    },
  );
}

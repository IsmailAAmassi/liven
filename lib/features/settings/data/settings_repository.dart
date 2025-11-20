import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/config/app_providers.dart';
import 'services/fake_settings_service.dart';
import 'services/real_settings_service.dart';
import '../domain/repositories/settings_repository.dart';

export '../domain/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  if (AppConfig.useFakeSettings) {
    return FakeSettingsService(storage: storage);
  }
  final api = ref.watch(appApiProvider);
  return RealSettingsService(
    api: api,
    storage: storage,
  );
});

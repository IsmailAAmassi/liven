import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/config/app_providers.dart';
import '../domain/repositories/auth_repository.dart';
import 'services/fake_auth_service.dart';
import 'services/real_auth_service.dart';

export '../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(authStorageProvider);
  if (AppConfig.useFakeAuth) {
    return FakeAuthService(storage: storage);
  }
  final api = ref.watch(appApiProvider);
  return RealAuthService(
    api: api,
    storage: storage,
  );
});

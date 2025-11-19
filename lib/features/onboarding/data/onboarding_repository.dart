import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_providers.dart';
import '../../../core/services/local_storage_service.dart';

class OnboardingRepository {
  OnboardingRepository(this._storageService);

  final LocalStorageService _storageService;

  Future<void> completeOnboarding() {
    return _storageService.setOnboardingCompleted(true);
  }

  Future<bool> isCompleted() {
    return _storageService.isOnboardingCompleted();
  }
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return OnboardingRepository(storage);
});

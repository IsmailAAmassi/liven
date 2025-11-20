import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/services/auth_storage.dart';
import '../../../core/services/local_storage_service.dart';

final profileCompletionGuardProvider = Provider<ProfileCompletionGuard>((ref) {
  final authStorage = ref.watch(authStorageProvider);
  final localStorage = ref.watch(localStorageServiceProvider);
  return ProfileCompletionGuard(
    authStorage: authStorage,
    localStorage: localStorage,
  );
});

class ProfileCompletionGuard {
  ProfileCompletionGuard({
    required AuthStorage authStorage,
    required LocalStorageService localStorage,
    DateTime Function()? clock,
  })  : _authStorage = authStorage,
        _localStorage = localStorage,
        _clock = clock ?? DateTime.now;

  final AuthStorage _authStorage;
  final LocalStorageService _localStorage;
  final DateTime Function() _clock;

  bool get isCompletionRequired => AppConfig.completeProfileRequired;

  Future<bool> shouldShowCompletion({bool? profileCompleted}) async {
    final completed = profileCompleted ??
        (await _authStorage.getProfileCompleted()) ??
        true;
    if (completed) return false;
    if (isCompletionRequired) return true;

    final lastPrompt = await _localStorage.getCompleteProfilePromptedAt();
    if (lastPrompt == null) return true;
    final interval = AppConfig.completeProfileReminderIntervalMinutes;
    if (interval <= 0) return true;
    return _clock().difference(lastPrompt).inMinutes >= interval;
  }

  Future<void> markPrompted() {
    return _localStorage.setCompleteProfilePromptedAt(_clock());
  }
}

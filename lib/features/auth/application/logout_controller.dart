import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/auth_storage.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../main/presentation/main_screen.dart';
import '../data/auth_repository.dart';
import '../presentation/login_screen.dart';

final logoutControllerProvider = Provider<LogoutController>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final authStorage = ref.watch(authStorageProvider);
  final localStorage = ref.watch(localStorageServiceProvider);
  final router = ref.watch(appRouterProvider);
  return LogoutController(
    ref: ref,
    repository: repository,
    authStorage: authStorage,
    localStorage: localStorage,
    router: router,
  );
});

class LogoutController {
  LogoutController({
    required Ref ref,
    required AuthRepository repository,
    required AuthStorage authStorage,
    required LocalStorageService localStorage,
    required GoRouter router,
  })  : _ref = ref,
        _repository = repository,
        _authStorage = authStorage,
        _localStorage = localStorage,
        _router = router;

  final Ref _ref;
  final AuthRepository _repository;
  final AuthStorage _authStorage;
  final LocalStorageService _localStorage;
  final GoRouter _router;

  Future<void> logout({BuildContext? context, bool showMessage = false}) async {
    await _repository.logout();
    await _localStorage.clearAuth();
    await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.loggedOut);
    _ref.read(mainTabIndexProvider.notifier).setIndex(MainScreen.homeTabIndex);
    _router.go(LoginScreen.routePath);

    if (context != null && showMessage) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.logout_success)),
        );
    }
  }

  Future<bool> ensureValidAuthToken({BuildContext? context}) async {
    final token = await _authStorage.getAuthToken();
    final hasToken = token != null && token.isNotEmpty;
    if (hasToken) return true;

    await logout(context: context);
    return false;
  }
}

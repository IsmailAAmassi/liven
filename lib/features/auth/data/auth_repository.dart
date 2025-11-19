import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_providers.dart';
import '../../../core/services/fake_auth_service.dart';
import '../../../core/services/local_storage_service.dart';

class AuthRepository {
  AuthRepository(this._fakeAuthService, this._localStorageService);

  final FakeAuthService _fakeAuthService;
  final LocalStorageService _localStorageService;

  Future<void> login({required String identifier, required String password}) {
    return _fakeAuthService.login(identifier: identifier, password: password);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _fakeAuthService.register(name: name, email: email, password: password);
  }

  Future<void> requestPasswordReset(String identifier) {
    return _fakeAuthService.requestPasswordReset(identifier);
  }

  Future<void> verifyOtp(String code) {
    return _fakeAuthService.verifyOtp(code);
  }

  Future<void> resetPassword({
    required String identifier,
    required String password,
  }) {
    return _fakeAuthService.resetPassword(identifier: identifier, password: password);
  }

  Future<void> clearAuth() async {
    await _localStorageService.clearAuth();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.watch(fakeAuthServiceProvider);
  final storage = ref.watch(localStorageServiceProvider);
  return AuthRepository(service, storage);
});

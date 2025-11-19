import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/fake_auth_service.dart';
import '../../main/presentation/main_screen.dart';
import '../data/auth_repository.dart';
import 'login_screen.dart';
import 'otp_screen.dart';
import 'reset_password_screen.dart';

class AuthState {
  const AuthState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;

  AuthState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum OtpFlowType { register, forgotPassword }

class OtpScreenArgs {
  const OtpScreenArgs({required this.flowType, required this.identifier});

  final OtpFlowType flowType;
  final String identifier;
}

class ResetPasswordArgs {
  const ResetPasswordArgs({required this.identifier});

  final String identifier;
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthViewModel(ref, repository);
});

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel(this._ref, this._repository) : super(const AuthState());

  final Ref _ref;
  final AuthRepository _repository;

  Future<void> login({required String identifier, required String password}) async {
    state = const AuthState(isLoading: true);
    try {
      await _repository.login(identifier: identifier, password: password);
      await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.authenticated);
      _ref.read(appRouterProvider).go(MainScreen.routePath);
      state = const AuthState();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(error));
    }
  }

  Future<void> browseAsGuest() async {
    await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.guest);
    await _ref.read(onboardingCompletedProvider.notifier).markCompleted();
    _ref.read(appRouterProvider).go(MainScreen.routePath);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState(isLoading: true);
    try {
      await _repository.register(name: name, email: email, password: password);
      state = const AuthState();
      _ref.read(appRouterProvider).go(
        OtpScreen.routePath,
        extra: OtpScreenArgs(flowType: OtpFlowType.register, identifier: email),
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(error));
    }
  }

  Future<void> requestPasswordReset(String identifier) async {
    state = const AuthState(isLoading: true);
    try {
      await _repository.requestPasswordReset(identifier);
      state = const AuthState();
      _ref.read(appRouterProvider).go(
        OtpScreen.routePath,
        extra:
            OtpScreenArgs(flowType: OtpFlowType.forgotPassword, identifier: identifier),
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(error));
    }
  }

  Future<void> verifyOtp(String code, OtpScreenArgs args) async {
    state = const AuthState(isLoading: true);
    try {
      await _repository.verifyOtp(code);
      state = const AuthState();
      final router = _ref.read(appRouterProvider);
      if (args.flowType == OtpFlowType.register) {
        await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.authenticated);
        router.go(MainScreen.routePath);
      } else {
        router.go(
          ResetPasswordScreen.routePath,
          extra: ResetPasswordArgs(identifier: args.identifier),
        );
      }
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(error));
    }
  }

  Future<void> resetPassword({
    required String identifier,
    required String password,
  }) async {
    state = const AuthState(isLoading: true);
    try {
      await _repository.resetPassword(identifier: identifier, password: password);
      await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.loggedOut);
      state = const AuthState();
      _ref.read(appRouterProvider).go(LoginScreen.routePath);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _mapError(error));
    }
  }

  Future<void> logout() async {
    await _repository.clearAuth();
    await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.loggedOut);
    _ref.read(appRouterProvider).go(LoginScreen.routePath);
  }

  String _mapError(Object error) {
    if (error is FakeAuthException) {
      return error.message;
    }
    debugPrint('Auth error: $error');
    return 'Something went wrong. Please try again.';
  }
}

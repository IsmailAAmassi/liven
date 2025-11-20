import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/network/api_result.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
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
    final fcmToken = await _ref.read(fcmServiceProvider).getToken();
    final result = await _repository.login(
      identifier: identifier,
      password: password,
      fcmToken: fcmToken,
    );
    final errorMessage = _errorFromResult(result);
    if (errorMessage != null) {
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return;
    }
    await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.authenticated);
    _ref.read(appRouterProvider).go(MainScreen.routePath);
    state = const AuthState();
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
    final fcmToken = await _ref.read(fcmServiceProvider).getToken();
    final result = await _repository.register(
      name: name,
      email: email,
      password: password,
      fcmToken: fcmToken,
    );
    final errorMessage = _errorFromResult(result);
    if (errorMessage != null) {
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return;
    }
    state = const AuthState();
    _ref.read(appRouterProvider).go(
      OtpScreen.routePath,
      extra: OtpScreenArgs(flowType: OtpFlowType.register, identifier: email),
    );
  }

  Future<void> requestPasswordReset(String identifier) async {
    state = const AuthState(isLoading: true);
    final result = await _repository.requestPasswordReset(identifier);
    final errorMessage = _errorFromResult(result);
    if (errorMessage != null) {
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return;
    }
    state = const AuthState();
    _ref.read(appRouterProvider).go(
      OtpScreen.routePath,
      extra: OtpScreenArgs(flowType: OtpFlowType.forgotPassword, identifier: identifier),
    );
  }

  Future<void> verifyOtp(String code, OtpScreenArgs args) async {
    state = const AuthState(isLoading: true);
    final result = await _repository.verifyOtp(code);
    final errorMessage = _errorFromResult(result);
    if (errorMessage != null) {
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return;
    }
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
  }

  Future<void> resetPassword({
    required String identifier,
    required String password,
  }) async {
    state = const AuthState(isLoading: true);
    final result = await _repository.resetPassword(identifier: identifier, password: password);
    final errorMessage = _errorFromResult(result);
    if (errorMessage != null) {
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return;
    }
    await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.loggedOut);
    state = const AuthState();
    _ref.read(appRouterProvider).go(LoginScreen.routePath);
  }

  Future<void> logout() async {
    state = const AuthState(isLoading: true);
    final result = await _repository.logout();
    final errorMessage = _errorFromResult(result);
    if (errorMessage != null) {
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return;
    }
    await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.loggedOut);
    _ref.read(appRouterProvider).go(LoginScreen.routePath);
    state = const AuthState();
  }

  String? _errorFromResult<T>(ApiResult<T> result) {
    if (result is ApiError<T>) {
      return _mapFailure(result.failure);
    }
    return null;
  }

  String _mapFailure(ApiFailure failure) {
    final locale = _ref.read(localeProvider);
    final l10n = lookupAppLocalizations(locale);
    switch (failure.messageKey) {
      case 'errorInvalidCredentials':
        return l10n.errorInvalidCredentials;
      case 'errorInvalidRegistration':
        return l10n.errorInvalidRegistration;
      case 'errorIdentifierRequired':
        return l10n.errorIdentifierRequired;
      case 'errorInvalidResetData':
        return l10n.errorInvalidResetData;
      case 'errorIncorrectOtp':
        return l10n.errorIncorrectOtp;
      case 'error_bad_request':
        return l10n.error_bad_request;
      case 'error_unauthorized':
        return l10n.error_unauthorized;
      case 'error_not_found':
        return l10n.error_not_found;
      case 'error_validation':
        return l10n.error_validation;
      case 'error_server':
        return l10n.error_server;
      case 'error_unknown':
        return l10n.error_unknown;
      default:
        return l10n.errorGeneric;
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/network/api_result.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../main/presentation/main_screen.dart';
import '../../profile/presentation/complete_profile_screen.dart';
import '../domain/models/auth_session.dart';
import '../domain/models/forgot_password_result.dart';
import '../domain/models/register_result.dart';
import '../domain/models/reset_password_result.dart';
import '../data/auth_repository.dart';
import 'login_screen.dart';
import 'otp_screen.dart';
import 'reset_password_screen.dart';

class AuthState {
  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  AuthState copyWith({bool? isLoading, String? errorMessage, String? successMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

enum OtpFlow { register, forgotPassword }

class OtpScreenArgs {
  const OtpScreenArgs({
    required this.flowType,
    required this.phone,
    this.initialMessage,
  });

  final OtpFlow flowType;
  final String phone;
  final String? initialMessage;
}

class ResetPasswordArgs {
  const ResetPasswordArgs({required this.phone});

  final String phone;
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthViewModel(ref, repository);
});

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel(this._ref, this._repository) : super(const AuthState());

  final Ref _ref;
  final AuthRepository _repository;

  Future<void> login({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    state = const AuthState(isLoading: true);
    final result = await _repository.login(
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );
    final errorMessage = _errorFromResult(result);
    if (errorMessage != null) {
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return;
    }
    final session = (result as ApiSuccess<AuthSession>).data;
    await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.authenticated);
    if (session.profileCompleted) {
      _ref.read(appRouterProvider).go(MainScreen.routePath);
    } else {
      _ref.read(appRouterProvider).go(CompleteProfileScreen.routePath);
    }
    state = const AuthState();
  }

  Future<void> browseAsGuest() async {
    await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.guest);
    await _ref.read(onboardingCompletedProvider.notifier).markCompleted();
    _ref.read(appRouterProvider).go(MainScreen.routePath);
  }

  Future<void> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    state = const AuthState(isLoading: true);
    final l10n = _currentL10n;
    final result = await _repository.register(
      phone: phone,
      password: password,
      name: name,
    );
    final errorMessage = _registerError(result);
    if (errorMessage != null) {
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return;
    }
    state = const AuthState();
    _ref.read(appRouterProvider).go(
      OtpScreen.routePath,
      extra: OtpScreenArgs(
        flowType: OtpFlow.register,
        phone: phone,
        initialMessage: l10n.otpSentMessage,
      ),
    );
  }

  Future<void> requestPasswordReset(String phone) async {
    state = const AuthState(isLoading: true);
    final l10n = _currentL10n;
    final result = await _repository.forgotPassword(phone: phone);
    final errorMessage = _mapForgotPasswordError(result);
    if (errorMessage != null) {
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return;
    }
    state = const AuthState();
    _ref.read(appRouterProvider).go(
      OtpScreen.routePath,
      extra: OtpScreenArgs(
        flowType: OtpFlow.forgotPassword,
        phone: phone,
        initialMessage: result.message ?? l10n.otpSentMessage,
      ),
    );
  }

  Future<void> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AuthState(isLoading: true);
    final result = await _repository.resetPassword(
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    final errorMessage = _mapResetPasswordError(result);
    if (errorMessage != null) {
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return;
    }
    await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.loggedOut);
    state = AuthState(successMessage: result.message ?? _currentL10n.resetPasswordSuccessMessage);
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
      case 'auth_invalid_credentials':
        return failure.details?['message'] as String? ?? l10n.authInvalidCredentials;
      case 'auth_login_failed':
        return l10n.authLoginFailed;
      case 'auth_register_failed':
        return l10n.authRegisterFailed;
      case 'errorInvalidRegistration':
        return l10n.errorInvalidRegistration;
      case 'errorIdentifierRequired':
        return l10n.errorIdentifierRequired;
      case 'errorInvalidResetData':
        return l10n.errorInvalidResetData;
      case 'errorIncorrectOtp':
        return l10n.errorIncorrectOtp;
      case 'error_network':
        return l10n.errorNetwork;
      case 'validationPhoneRequired':
        return l10n.validationPhone;
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

  String? _registerError(RegisterResult result) {
    if (result.success) return null;
    final locale = _ref.read(localeProvider);
    final l10n = lookupAppLocalizations(locale);
    if (result.hasErrors) {
      final mappedErrors = result.errors!
          .map((error) => _mapRegisterValidationError(error, l10n))
          .toList();
      return mappedErrors.join('\n');
    }
    if (result.messageKey != null) {
      return _mapFailure(ApiFailure(messageKey: result.messageKey!));
    }
    if (result.message != null && result.message!.isNotEmpty) {
      return result.message;
    }
    return l10n.authRegisterFailed;
  }

  String _mapRegisterValidationError(String error, AppLocalizations l10n) {
    final normalized = error.toLowerCase();
    if (normalized.contains('phone has already been taken')) {
      return l10n.authErrorPhoneTaken;
    }
    if (normalized.contains('password') && normalized.contains('6')) {
      return l10n.authErrorPasswordTooShort;
    }
    return error;
  }

  String? _mapForgotPasswordError(ForgotPasswordResult result) {
    if (result.success) return null;
    final l10n = _currentL10n;
    if (result.hasErrors) {
      return result.errors!.join('\n');
    }
    if (result.message != null && result.message!.isNotEmpty) {
      return result.message;
    }
    if (result.messageKey != null) {
      return _mapFailure(ApiFailure(messageKey: result.messageKey));
    }
    return l10n.otpGenericError;
  }

  String? _mapResetPasswordError(ResetPasswordResult result) {
    if (result.success) return null;
    final l10n = _currentL10n;
    if (result.hasErrors) {
      return result.errors!.join('\n');
    }
    if (result.message != null && result.message!.isNotEmpty) {
      return result.message;
    }
    if (result.messageKey != null) {
      return _mapFailure(ApiFailure(messageKey: result.messageKey));
    }
    return l10n.errorGeneric;
  }

  AppLocalizations get _currentL10n {
    final locale = _ref.read(localeProvider);
    return lookupAppLocalizations(locale);
  }
}

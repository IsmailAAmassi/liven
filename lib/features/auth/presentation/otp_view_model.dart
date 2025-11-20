import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../main/presentation/main_screen.dart';
import '../../profile/presentation/complete_profile_screen.dart';
import '../data/auth_repository.dart';
import '../domain/models/forgot_password_result.dart';
import '../domain/models/otp_send_result.dart';
import '../domain/models/otp_verify_result.dart';
import 'auth_view_model.dart';
import 'reset_password_screen.dart';

class OtpState {
  const OtpState({
    required this.phone,
    this.isVerifying = false,
    this.isResending = false,
    this.errorMessage,
    this.successMessage,
    this.secondsRemaining = 0,
  });

  final String phone;
  final bool isVerifying;
  final bool isResending;
  final String? errorMessage;
  final String? successMessage;
  final int secondsRemaining;

  bool get canResend => !isResending && secondsRemaining == 0;

  OtpState copyWith({
    String? phone,
    bool? isVerifying,
    bool? isResending,
    Object? errorMessage = _messageSentinel,
    Object? successMessage = _messageSentinel,
    int? secondsRemaining,
  }) {
    return OtpState(
      phone: phone ?? this.phone,
      isVerifying: isVerifying ?? this.isVerifying,
      isResending: isResending ?? this.isResending,
      errorMessage:
          identical(errorMessage, _messageSentinel) ? this.errorMessage : errorMessage as String?,
      successMessage:
          identical(successMessage, _messageSentinel) ? this.successMessage : successMessage as String?,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
    );
  }
}

const _messageSentinel = Object();

final otpViewModelProvider = StateNotifierProvider.autoDispose.family<OtpViewModel, OtpState, OtpScreenArgs>((ref, args) {
  final repository = ref.watch(authRepositoryProvider);
  return OtpViewModel(ref, repository, args);
});

class OtpViewModel extends StateNotifier<OtpState> {
  OtpViewModel(this._ref, this._repository, this._args)
      : super(
          OtpState(
            phone: _args.phone,
            successMessage: _args.initialMessage,
            secondsRemaining: _args.initialMessage != null ? 60 : 0,
          ),
        ) {
    if (state.secondsRemaining > 0) {
      _startCountdown();
    }
  }

  final Ref _ref;
  final AuthRepository _repository;
  final OtpScreenArgs _args;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> verifyOtp(String code) async {
    if (code.isEmpty) {
      state = state.copyWith(errorMessage: _l10n.otpRequired, isVerifying: false);
      return;
    }
    state = state.copyWith(isVerifying: true, errorMessage: null, successMessage: null);
    final result = await _repository.verifyOtp(phone: state.phone, otpCode: code);
    if (!result.success) {
      final message = _mapVerifyFailure(result);
      state = state.copyWith(isVerifying: false, errorMessage: message);
      return;
    }
    state = OtpState(phone: result.phone ?? state.phone);
    final router = _ref.read(appRouterProvider);
    if (_args.flowType == OtpFlow.register) {
      await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.authenticated);
      if (result.profileCompleted == true) {
        router.go(MainScreen.routePath);
      } else {
        router.go(CompleteProfileScreen.routePath);
      }
    } else {
      await _repository.clearAuth();
      await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.loggedOut);
      router.go(
        ResetPasswordScreen.routePath,
        extra: ResetPasswordArgs(phone: state.phone),
      );
    }
  }

  Future<void> resendOtp() async {
    if (!state.canResend) return;
    state = state.copyWith(isResending: true, errorMessage: null, successMessage: null);
    if (_args.flowType == OtpFlow.forgotPassword && state.phone != _args.phone) {
      final result = await _repository.forgotPassword(phone: state.phone);
      if (!result.success) {
        final message = _mapForgotFailure(result);
        state = state.copyWith(isResending: false, errorMessage: message);
        return;
      }
      state = state.copyWith(
        isResending: false,
        successMessage: result.message ?? _l10n.otpSentMessage,
        secondsRemaining: 60,
      );
      _startCountdown();
      return;
    }
    final result = await _repository.sendOtp(phone: state.phone);
    if (!result.success) {
      final message = _mapSendFailure(result);
      state = state.copyWith(isResending: false, errorMessage: message);
      return;
    }
    state = state.copyWith(
      isResending: false,
      successMessage: result.message ?? _l10n.otpSentMessage,
      secondsRemaining: 60,
    );
    _startCountdown();
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone, errorMessage: null);
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining <= 1) {
        state = state.copyWith(secondsRemaining: 0);
        timer.cancel();
      } else {
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      }
    });
  }

  String _mapVerifyFailure(OtpVerifyResult result) {
    if (result.hasErrors) {
      return result.errors!.join('\n');
    }
    if (result.message != null && result.message!.isNotEmpty) {
      return result.message!;
    }
    return _messageFromKey(result.messageKey) ?? _l10n.otpGenericError;
  }

  String _mapSendFailure(OtpSendResult result) {
    if (result.hasErrors) {
      return result.errors!.join('\n');
    }
    if (result.message != null && result.message!.isNotEmpty) {
      return result.message!;
    }
    return _messageFromKey(result.messageKey) ?? _l10n.otpGenericError;
  }

  String _mapForgotFailure(ForgotPasswordResult result) {
    if (result.hasErrors) {
      return result.errors!.join('\n');
    }
    if (result.message != null && result.message!.isNotEmpty) {
      return result.message!;
    }
    return _messageFromKey(result.messageKey) ?? _l10n.otpGenericError;
  }

  String? _messageFromKey(String? key) {
    switch (key) {
      case 'otp_invalid':
        return _l10n.otpInvalid;
      case 'otp_required':
        return _l10n.otpRequired;
      case 'otp_invalid_mobile':
        return _l10n.otpInvalidMobile;
      case 'otp_generic_error':
        return _l10n.otpGenericError;
      case 'error_network':
        return _l10n.errorNetwork;
      case 'error_validation':
        return _l10n.error_validation;
      case 'validationPhoneRequired':
        return _l10n.validationPhone;
      default:
        return null;
    }
  }

  AppLocalizations get _l10n {
    final locale = _ref.read(localeProvider);
    return lookupAppLocalizations(locale);
  }
}

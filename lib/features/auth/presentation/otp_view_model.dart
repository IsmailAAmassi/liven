import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../main/presentation/main_screen.dart';
import '../../profile/presentation/complete_profile_screen.dart';
import '../data/auth_repository.dart';
import '../domain/models/otp_send_result.dart';
import '../domain/models/otp_verify_result.dart';
import 'auth_view_model.dart';
import 'reset_password_screen.dart';

class OtpState {
  const OtpState({
    this.isVerifying = false,
    this.isResending = false,
    this.errorMessage,
    this.successMessage,
    this.secondsRemaining = 0,
  });

  final bool isVerifying;
  final bool isResending;
  final String? errorMessage;
  final String? successMessage;
  final int secondsRemaining;

  bool get canResend => !isResending && secondsRemaining == 0;

  OtpState copyWith({
    bool? isVerifying,
    bool? isResending,
    Object? errorMessage = _messageSentinel,
    Object? successMessage = _messageSentinel,
    int? secondsRemaining,
  }) {
    return OtpState(
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

final otpViewModelProvider =
    StateNotifierProvider.autoDispose.family<OtpViewModel, OtpState, OtpScreenArgs>((ref, args) {
  final repository = ref.watch(authRepositoryProvider);
  return OtpViewModel(ref, repository, args);
});

class OtpViewModel extends StateNotifier<OtpState> {
  OtpViewModel(this._ref, this._repository, this._args) : super(const OtpState());

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
    final result = await _repository.verifyOtp(phone: _args.identifier, otpCode: code);
    if (!result.success) {
      final message = _mapVerifyFailure(result);
      state = state.copyWith(isVerifying: false, errorMessage: message);
      return;
    }
    state = const OtpState();
    final router = _ref.read(appRouterProvider);
    if (_args.flowType == OtpFlowType.register) {
      await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.authenticated);
      if (result.profileCompleted == true) {
        router.go(MainScreen.routePath);
      } else {
        router.go(CompleteProfileScreen.routePath);
      }
    } else {
      router.go(
        ResetPasswordScreen.routePath,
        extra: ResetPasswordArgs(identifier: _args.identifier),
      );
    }
  }

  Future<void> resendOtp() async {
    if (!state.canResend) return;
    state = state.copyWith(isResending: true, errorMessage: null, successMessage: null);
    final result = await _repository.sendOtp(phone: _args.identifier);
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
      default:
        return null;
    }
  }

  AppLocalizations get _l10n {
    final locale = _ref.read(localeProvider);
    return lookupAppLocalizations(locale);
  }
}

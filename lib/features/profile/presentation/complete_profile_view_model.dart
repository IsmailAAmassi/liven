import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../main/presentation/main_screen.dart';
import '../application/profile_completion_guard.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/domain/models/complete_profile_result.dart';

class CompleteProfileState {
  const CompleteProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.fieldErrors = const {},
    this.successMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final String? successMessage;

  CompleteProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    String? successMessage,
  }) {
    return CompleteProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      successMessage: successMessage,
    );
  }
}

final completeProfileViewModelProvider =
    StateNotifierProvider.autoDispose<CompleteProfileViewModel, CompleteProfileState>(
        (ref) {
  final repository = ref.watch(authRepositoryProvider);
  final guard = ref.watch(profileCompletionGuardProvider);
  return CompleteProfileViewModel(ref, repository, guard);
});

class CompleteProfileViewModel extends StateNotifier<CompleteProfileState> {
  CompleteProfileViewModel(this._ref, this._repository, this._guard)
      : super(const CompleteProfileState());

  final Ref _ref;
  final AuthRepository _repository;
  final ProfileCompletionGuard _guard;

  Future<void> submit({
    required int age,
    required String gender,
    required int length,
    required int weight,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, fieldErrors: {});
    final result = await _repository.completeProfile(
      age: age,
      gender: gender,
      length: length,
      weight: weight,
    );

    if (!result.success) {
      final message = _mapFailure(result);
      final fieldErrors = result.fieldErrors ?? _mapFieldErrors(result.errors);
      state = state.copyWith(
        isLoading: false,
        errorMessage: message,
        fieldErrors: fieldErrors,
      );
      return;
    }

    await _ref.read(authStatusProvider.notifier).setStatus(AuthStatus.authenticated);
    await _guard.markPrompted();
    state = state.copyWith(
      isLoading: false,
      successMessage: result.message ?? _currentL10n.completeProfileSuccess,
    );
    _ref.read(appRouterProvider).go(MainScreen.routePath);
  }

  String? _mapFailure(CompleteProfileResult result) {
    if (result.messageKey == null && (result.message?.isNotEmpty ?? false)) {
      return result.message;
    }

    switch (result.messageKey) {
      case 'error_network':
        return _currentL10n.errorNetwork;
      case 'error_validation':
        return result.message ?? _currentL10n.error_validation;
      default:
        return result.message ?? _currentL10n.completeProfileError;
    }
  }

  Map<String, String> _mapFieldErrors(List<String>? errors) {
    if (errors == null) return {};
    final fieldErrors = <String, String>{};
    for (final error in errors) {
      final normalized = error.toLowerCase();
      if (normalized.contains('age')) {
        fieldErrors['age'] = error;
      } else if (normalized.contains('gender')) {
        fieldErrors['gender'] = error;
      } else if (normalized.contains('length') || normalized.contains('height')) {
        fieldErrors['length'] = error;
      } else if (normalized.contains('weight')) {
        fieldErrors['weight'] = error;
      }
    }
    return fieldErrors;
  }

  AppLocalizations get _currentL10n {
    final locale = _ref.read(localeProvider);
    return lookupAppLocalizations(locale);
  }
}

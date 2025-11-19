import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/login_screen.dart';
import '../../main/presentation/main_screen.dart';
import '../data/onboarding_repository.dart';

class OnboardingState {
  const OnboardingState({this.pageIndex = 0});

  final int pageIndex;

  OnboardingState copyWith({int? pageIndex}) {
    return OnboardingState(pageIndex: pageIndex ?? this.pageIndex);
  }
}

enum OnboardingPageType { language, theme, content }

class OnboardingPageData {
  const OnboardingPageData({
    required this.titleBuilder,
    required this.descriptionBuilder,
    required this.icon,
    required this.background,
    required this.featureColor,
  });

  final String Function(AppLocalizations) titleBuilder;
  final String Function(AppLocalizations) descriptionBuilder;
  final IconData icon;
  final Color background;
  final Color featureColor;
}

class OnboardingPageConfig {
  const OnboardingPageConfig.language()
      : type = OnboardingPageType.language,
        data = null,
        background = const Color(0xFFF4F1FF);

  const OnboardingPageConfig.theme()
      : type = OnboardingPageType.theme,
        data = null,
        background = const Color(0xFFEFF6FB);

  const OnboardingPageConfig.content(this.data)
      : type = OnboardingPageType.content,
        background = data.background;

  final OnboardingPageType type;
  final OnboardingPageData? data;
  final Color background;
}

final onboardingPages = [
  const OnboardingPageConfig.language(),
  const OnboardingPageConfig.theme(),
  OnboardingPageConfig.content(
    OnboardingPageData(
      titleBuilder: (l10n) => l10n.onboardingPageOneTitle,
      descriptionBuilder: (l10n) => l10n.onboardingPageOneDescription,
      icon: Icons.auto_awesome,
      background: const Color(0xFFFAF5FF),
      featureColor: const Color(0xFF6D2E75),
    ),
  ),
  OnboardingPageConfig.content(
    OnboardingPageData(
      titleBuilder: (l10n) => l10n.onboardingPageTwoTitle,
      descriptionBuilder: (l10n) => l10n.onboardingPageTwoDescription,
      icon: Icons.devices_other,
      background: const Color(0xFFEFE7F2),
      featureColor: const Color(0xFF835690),
    ),
  ),
  OnboardingPageConfig.content(
    OnboardingPageData(
      titleBuilder: (l10n) => l10n.onboardingPageThreeTitle,
      descriptionBuilder: (l10n) => l10n.onboardingPageThreeDescription,
      icon: Icons.tune,
      background: const Color(0xFFF6EDF8),
      featureColor: const Color(0xFFAA6FAD),
    ),
  ),
];

final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, OnboardingState>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return OnboardingViewModel(ref, repository);
});

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  OnboardingViewModel(this._ref, this._repository) : super(const OnboardingState());

  final Ref _ref;
  final OnboardingRepository _repository;

  List<OnboardingPageData> get pages => onboardingPages;

  void setPage(int index) {
    state = state.copyWith(pageIndex: index);
  }

  Future<void> next() async {
    if (state.pageIndex < pages.length - 1) {
      state = state.copyWith(pageIndex: state.pageIndex + 1);
    } else {
      await complete();
    }
  }

  Future<void> skip() async {
    await complete();
  }

  Future<void> complete() async {
    await _repository.completeOnboarding();
    await _ref.read(onboardingCompletedProvider.notifier).markCompleted();

    final router = _ref.read(appRouterProvider);
    final status = _ref.read(authStatusProvider);
    if (status == AuthStatus.authenticated || status == AuthStatus.guest) {
      router.go(MainScreen.routePath);
    } else {
      router.go(LoginScreen.routePath);
    }
  }
}

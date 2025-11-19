import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
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

class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.background,
    required this.featureColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color background;
  final Color featureColor;
}

final onboardingPages = [
  const OnboardingPageData(
    title: 'Discover tailored experiences',
    description: 'Personalized content crafted for both Arabic and English audiences.',
    icon: Icons.auto_awesome,
    background: Color(0xFFFAF5FF),
    featureColor: Color(0xFF6D2E75),
  ),
  const OnboardingPageData(
    title: 'Stay in sync everywhere',
    description: 'Access your account on any device with secure cloud sync.',
    icon: Icons.devices_other,
    background: Color(0xFFEFE7F2),
    featureColor: Color(0xFF835690),
  ),
  const OnboardingPageData(
    title: 'Control every detail',
    description: 'Themes, language, and privacy controls are always one tap away.',
    icon: Icons.tune,
    background: Color(0xFFF6EDF8),
    featureColor: Color(0xFFAA6FAD),
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

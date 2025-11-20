import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/login_screen.dart';
import '../../main/presentation/main_screen.dart';
import '../../onboarding/presentation/onboarding_screen.dart';
import '../../profile/application/profile_completion_guard.dart';
import '../../profile/presentation/complete_profile_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const routePath = '/splash';
  static const routeName = 'splash';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    final authNotifier = ref.read(authStatusProvider.notifier);
    final onboardingNotifier = ref.read(onboardingCompletedProvider.notifier);
    final permissionController = ref.read(permissionControllerProvider);

    while (!authNotifier.isInitialized || !onboardingNotifier.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 150));
    }

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    await permissionController.requestNotificationOnLaunch(context);

    final router = ref.read(appRouterProvider);
    final onboardingCompleted = ref.read(onboardingCompletedProvider);
    final authStatus = ref.read(authStatusProvider);
    final guard = ref.read(profileCompletionGuardProvider);
    final profileCompleted =
        await ref.read(authStorageProvider).getProfileCompleted() ?? true;

    if (!onboardingCompleted) {
      router.go(OnboardingScreen.routePath);
    } else if (authStatus == AuthStatus.authenticated ||
        authStatus == AuthStatus.guest) {
      if (authStatus == AuthStatus.authenticated) {
        final shouldShow =
            await guard.shouldShowCompletion(profileCompleted: profileCompleted);
        if (shouldShow) {
          await guard.markPrompted();
          router.go(CompleteProfileScreen.routePath);
        } else {
          router.go(MainScreen.routePath);
        }
      } else {
        router.go(MainScreen.routePath);
      }
    } else {
      router.go(LoginScreen.routePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D2E75), Color(0xFF935F9F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.appTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

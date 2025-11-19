import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/main/presentation/main_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/terms/presentation/terms_of_use_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = createRouter();
  ref.onDispose(router.dispose);
  return router;
});

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: SplashScreen.routePath,
    routes: [
      GoRoute(
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        pageBuilder: (context, state) => _buildPage(state, const SplashScreen()),
      ),
      GoRoute(
        path: OnboardingScreen.routePath,
        name: OnboardingScreen.routeName,
        pageBuilder: (context, state) => _buildPage(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: LoginScreen.routePath,
        name: LoginScreen.routeName,
        pageBuilder: (context, state) => _buildPage(state, const LoginScreen()),
      ),
      GoRoute(
        path: RegisterScreen.routePath,
        name: RegisterScreen.routeName,
        pageBuilder: (context, state) => _buildPage(state, const RegisterScreen()),
      ),
      GoRoute(
        path: ForgotPasswordScreen.routePath,
        name: ForgotPasswordScreen.routeName,
        pageBuilder: (context, state) =>
            _buildPage(state, const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: OtpScreen.routePath,
        name: OtpScreen.routeName,
        pageBuilder: (context, state) {
          final args = state.extra as OtpScreenArgs?;
          if (args == null) {
            throw ArgumentError('OtpScreenArgs are required');
          }
          return _buildPage(state, OtpScreen(args: args));
        },
      ),
      GoRoute(
        path: ResetPasswordScreen.routePath,
        name: ResetPasswordScreen.routeName,
        pageBuilder: (context, state) {
          final args = state.extra as ResetPasswordArgs?;
          if (args == null) {
            throw ArgumentError('ResetPasswordArgs are required');
          }
          return _buildPage(state, ResetPasswordScreen(args: args));
        },
      ),
      GoRoute(
        path: TermsOfUseScreen.routePath,
        name: TermsOfUseScreen.routeName,
        pageBuilder: (context, state) =>
            _buildPage(state, const TermsOfUseScreen()),
      ),
      GoRoute(
        path: MainScreen.routePath,
        name: MainScreen.routeName,
        pageBuilder: (context, state) => _buildPage(state, const MainScreen()),
      ),
      GoRoute(
        path: SettingsScreen.routePath,
        name: SettingsScreen.routeName,
        pageBuilder: (context, state) => _buildPage(state, const SettingsScreen()),
      ),
    ],
  );
}

CustomTransitionPage<void> _buildPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

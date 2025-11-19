import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';

/// Creates the application's router.
/// Keeping this as a factory makes it easy to inject dependencies later.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: HomeScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],
  );
}

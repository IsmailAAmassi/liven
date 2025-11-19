import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../terms/presentation/terms_of_use_screen.dart';
import '../../auth/presentation/auth_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routePath = '/settings';
  static const routeName = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: themeMode == ThemeMode.dark,
            onChanged: (_) => ref.read(themeModeProvider.notifier).toggleTheme(),
            title: const Text('Dark mode'),
            subtitle: const Text('Toggle between light and dark themes.'),
          ),
          SwitchListTile(
            value: locale.languageCode == 'ar',
            onChanged: (_) => ref.read(localeProvider.notifier).toggleLocale(),
            title: const Text('Arabic language'),
            subtitle: const Text('Switch between Arabic and English.'),
          ),
          ListTile(
            title: const Text('Terms of Use'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => ref.read(appRouterProvider).go(TermsOfUseScreen.routePath),
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () => ref.read(authViewModelProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}

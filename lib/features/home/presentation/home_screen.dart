import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_providers.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = l10n(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return AppScaffold(
      title: localization.appTitle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            localization.homeGreeting,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: localization.toggleTheme,
            onPressed: () {
              // State lives in Riverpod providers, so toggling the theme updates globally.
              final notifier = ref.read(themeModeProvider.notifier);
              notifier.state = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          const SizedBox(height: 16),
          AppButton(
            label: localization.changeLanguage,
            onPressed: () {
              // Switching locale via provider ensures MaterialApp rebuilds with the new language.
              final notifier = ref.read(localeProvider.notifier);
              notifier.state = locale.languageCode == 'en'
                  ? const Locale('ar')
                  : const Locale('en');
            },
          ),
        ],
      ),
    );
  }
}

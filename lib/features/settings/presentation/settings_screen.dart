import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_view_model.dart';
import '../../auth/presentation/widgets/logout_confirmation_dialog.dart';
import '../../main/presentation/main_screen.dart';
import '../../terms/presentation/terms_of_use_screen.dart';
import 'widgets/language_selector_sheet.dart';
import 'widgets/theme_selector_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routePath = '/settings';
  static const routeName = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.read(appRouterProvider);
    final language = AppLanguageX.fromLocale(locale);
    final theme = ThemePreferenceX.fromThemeMode(themeMode);

    return Scaffold(
      appBar: AppPageAppBar(
        title: l10n.settingsTitle,
        onBackPressed: () => router.go(MainScreen.routePath),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settingsLanguageLabel),
            subtitle: Text(l10n.moreLanguageSubtitle),
            trailing: Text('${language.flag}  ${language.label(l10n)}'),
            onTap: () => showLanguageSelectorSheet(context),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l10n.settingsThemeLabel),
            subtitle: Text(l10n.moreThemeSubtitle),
            trailing: Text(theme.label(l10n)),
            onTap: () => showThemeSelectorSheet(context),
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: Text(l10n.settingsTermsLabel),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => router.push(TermsOfUseScreen.routePath),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.settingsLogoutLabel),
            onTap: () async {
              final confirmed = await showLogoutConfirmationDialog(context);
              if (confirmed) {
                await ref.read(authViewModelProvider.notifier).logout();
              }
            },
          ),
        ],
      ),
    );
  }
}

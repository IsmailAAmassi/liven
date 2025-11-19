import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_view_model.dart';
import '../../auth/presentation/widgets/logout_confirmation_dialog.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../settings/presentation/widgets/language_selector_sheet.dart';
import '../../settings/presentation/widgets/theme_selector_sheet.dart';
import '../../terms/presentation/terms_of_use_screen.dart';
import 'about_screen.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  static const routePath = '/main/more';
  static const routeName = 'more';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final router = ref.read(appRouterProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final language = AppLanguageX.fromLocale(locale);
    final theme = ThemePreferenceX.fromThemeMode(themeMode);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(l10n.moreAbout),
          subtitle: Text(l10n.moreAboutSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => router.push(AboutScreen.routePath),
        ),
        ListTile(
          leading: const Icon(Icons.article_outlined),
          title: Text(l10n.moreTerms),
          subtitle: Text(l10n.moreTermsSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => router.push(TermsOfUseScreen.routePath),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(l10n.moreProfile),
          subtitle: Text(l10n.moreProfileSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => router.go(ProfileScreen.routePath),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n.moreLanguage),
          subtitle: Text(l10n.moreLanguageSubtitle),
          trailing: Text('${language.flag}  ${language.label(l10n)}'),
          onTap: () => showLanguageSelectorSheet(context),
        ),
        ListTile(
          leading: const Icon(Icons.brightness_6_outlined),
          title: Text(l10n.moreTheme),
          subtitle: Text(l10n.moreThemeSubtitle),
          trailing: Text(theme.label(l10n)),
          onTap: () => showThemeSelectorSheet(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(l10n.generalSettings),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => router.push(SettingsScreen.routePath),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(l10n.moreLogout),
          subtitle: Text(l10n.moreLogoutSubtitle),
          onTap: () async {
            final confirmed = await showLogoutConfirmationDialog(context);
            if (confirmed) {
              await ref.read(authViewModelProvider.notifier).logout();
            }
          },
        ),
      ],
    );
  }
}

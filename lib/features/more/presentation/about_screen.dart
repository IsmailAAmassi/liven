import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_page_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../../main/presentation/main_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const routePath = '/about';
  static const routeName = 'about';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppPageAppBar(
        title: l10n.moreAbout,
        onBackPressed: () => context.go(MainScreen.routePath),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.aboutTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.aboutDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.aboutMissionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.aboutMissionDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/services/zoom_service.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/settings_screen.dart';

class HomeTabScreen extends ConsumerWidget {
  const HomeTabScreen({super.key});

  static const routePath = '/main/home';
  static const routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final zoomState = ref.watch(zoomMeetingControllerProvider);
    final zoomPreset = ref.watch(zoomMeetingPresetProvider);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        AppText(
          l10n.homeWelcomeTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        AppText(
          l10n.homeWelcomeSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeCardTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.homeCardDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: l10n.homeOpenSettings,
                  onPressed: () =>
                      ref.read(appRouterProvider).go(SettingsScreen.routePath),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeZoomCardTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.homeZoomCardDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (!zoomPreset.isConfigured) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.homeZoomMissingConfig,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                if (zoomState.hasError) ...[
                  const SizedBox(height: 12),
                  Text(
                    zoomState.error is ZoomInitializationException
                        ? l10n.homeZoomInitError
                        : l10n.homeZoomError,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: 16),
                AppButton(
                  label: l10n.homeZoomJoinButton,
                  isLoading: zoomState.isLoading,
                  onPressed: zoomPreset.isConfigured
                      ? () => ref
                          .read(zoomMeetingControllerProvider.notifier)
                          .joinPresetMeeting()
                      : null,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          l10n.homeFeedTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        ...List.generate(3, (index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(l10n.homeFeedPlaceholderTitle),
              subtitle: Text(l10n.homeFeedPlaceholderSubtitle),
            ),
          );
        }),
      ],
    );
  }
}

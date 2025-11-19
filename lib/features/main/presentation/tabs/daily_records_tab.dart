import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';

class DailyRecordsScreen extends ConsumerWidget {
  const DailyRecordsScreen({super.key});

  static const routePath = '/main/records';
  static const routeName = 'records';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.dailyRecordsTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.dailyRecordsSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.dailyRecordsSectionTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...List.generate(5, (index) {
          final day = index + 1;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.event_note),
              title: Text(l10n.dailyRecordItemTitle(day)),
              subtitle: Text(l10n.dailyRecordItemSubtitle),
            ),
          );
        }),
        const SizedBox(height: 12),
        Text(
          l10n.dailyRecordsEmpty,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.outline),
        ),
      ],
    );
  }
}

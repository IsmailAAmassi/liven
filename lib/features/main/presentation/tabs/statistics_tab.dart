import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  static const routePath = '/main/statistics';
  static const routeName = 'statistics';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cards = [
      _StatCard(label: l10n.statisticsSessionsLabel, value: '12'),
      _StatCard(label: l10n.statisticsStreakLabel, value: '6'),
      _StatCard(label: l10n.statisticsCompletedLabel, value: '18'),
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.statisticsTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.statisticsOverview,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final cardWidth = isWide ? (constraints.maxWidth - 16) / 2 : double.infinity;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: cards
                  .map((card) => SizedBox(
                        width: cardWidth,
                        child: card,
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

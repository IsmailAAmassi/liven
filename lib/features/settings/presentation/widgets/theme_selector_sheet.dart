import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_enums.dart';
import '../../../../core/config/app_providers.dart';
import '../../../../l10n/app_localizations.dart';

Future<void> showThemeSelectorSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => const _ThemeSelectorSheet(),
  );
}

class _ThemeSelectorSheet extends ConsumerWidget {
  const _ThemeSelectorSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final selected = ThemePreferenceX.fromThemeMode(themeMode);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.themeSelectorTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...ThemePreference.values.map((preference) {
              final isSelected = preference == selected;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setTheme(preference.mode);
                    Navigator.of(context).pop();
                  },
                  leading: Icon(preference.icon),
                  title: Text(preference.label(l10n)),
                  subtitle: Text(preference.description(l10n)),
                  trailing: isSelected
                      ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                      : null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_enums.dart';
import '../../../../core/config/app_providers.dart';
import '../../../../l10n/app_localizations.dart';

Future<void> showLanguageSelectorSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => const _LanguageSelectorSheet(),
  );
}

class _LanguageSelectorSheet extends ConsumerWidget {
  const _LanguageSelectorSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final selected = AppLanguageX.fromLocale(locale);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.languageSelectorTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...AppLanguage.values.map((language) {
              final isSelected = language == selected;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () {
                    ref.read(localeProvider.notifier).setLocale(language.locale);
                    Navigator.of(context).pop();
                  },
                  leading: Text(language.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(language.label(l10n)),
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

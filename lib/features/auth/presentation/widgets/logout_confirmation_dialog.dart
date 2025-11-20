import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logout_confirm_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.logout_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.logout_ok),
          ),
        ],
      );
    },
  );
  return shouldLogout ?? false;
}

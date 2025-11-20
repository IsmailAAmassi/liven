import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  static const routePath = '/complete-profile';
  static const routeName = 'completeProfile';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.completeProfileTitle),
      ),
      body: Center(
        child: Text(l10n.completeProfilePlaceholder),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_enums.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/widgets/app_button.dart';
import '../../../l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const routePath = '/main/profile';
  static const routeName = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final status = ref.watch(authStatusProvider);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(l10n.profileTitle, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l10n.profileSubtitle, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(l10n.profileNameLabel),
            subtitle: const Text('Alex Johnson'),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(l10n.profileEmailLabel),
            subtitle: const Text('alex@example.com'),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.verified_user),
            title: Text(l10n.profileStatusLabel),
            subtitle: Text(status == AuthStatus.guest
                ? l10n.profileStatusGuest
                : l10n.profileStatusAuthenticated),
          ),
        ),
        const SizedBox(height: 24),
        AppButton(
          label: l10n.profileEditAction,
          onPressed: () {},
          variant: AppButtonVariant.outlined,
        ),
      ],
    );
  }
}

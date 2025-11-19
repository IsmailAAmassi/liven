import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/config/app_providers.dart';
import '../../../core/permissions/app_permission.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/widgets/app_button.dart';

class PermissionsStatusScreen extends ConsumerWidget {
  const PermissionsStatusScreen({super.key});

  static const routePath = '/permissions/status';
  static const routeName = 'permissionsStatus';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statusesAsync = ref.watch(permissionStatusesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.permissionsTitle),
      ),
      body: statusesAsync.when(
        data: (statuses) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.permissionsDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ...AppPermission.values.map((permission) {
                final status = statuses[permission] ?? PermissionStatus.denied;
                return _PermissionTile(
                  permission: permission,
                  status: status,
                  onRequest: () async {
                    final controller = ref.read(permissionControllerProvider);
                    await controller.ensurePermission(context, permission);
                    if (!context.mounted) return;
                    await ref.read(permissionStatusesProvider.notifier).refresh();
                  },
                  onOpenSettings: () async {
                    final controller = ref.read(permissionControllerProvider);
                    await controller.openSettings();
                    await ref.read(permissionStatusesProvider.notifier).refresh();
                  },
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.permission,
    required this.status,
    required this.onRequest,
    required this.onOpenSettings,
  });

  final AppPermission permission;
  final PermissionStatus status;
  final Future<void> Function()? onRequest;
  final Future<void> Function()? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusLabel = _statusLabel(l10n, status);
    final isGranted = status == PermissionStatus.granted ||
        status == PermissionStatus.limited ||
        status == PermissionStatus.provisional;
    final requiresSettings =
        status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted;
    final canRequest = !isGranted && !requiresSettings;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(permission.icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        permission.title(l10n),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        permission.statusDescription(l10n),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  statusLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (canRequest || requiresSettings)
              Row(
                children: [
                  if (canRequest)
                    Expanded(
                      child: AppButton(
                        label: l10n.permissionActionRequest,
                        onPressed: _wrapAsync(onRequest),
                      ),
                    ),
                  if (canRequest && requiresSettings)
                    const SizedBox(width: 8),
                  if (requiresSettings)
                    Expanded(
                      child: AppButton(
                        label: l10n.permissionActionGoToSettings,
                        onPressed: _wrapAsync(onOpenSettings),
                        variant: AppButtonVariant.outlined,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, PermissionStatus status) {
    switch (status) {
      case PermissionStatus.denied:
        return l10n.permissionStatusDenied;
      case PermissionStatus.granted:
        return l10n.permissionStatusAllowed;
      case PermissionStatus.restricted:
        return l10n.permissionStatusRestricted;
      case PermissionStatus.limited:
        return l10n.permissionStatusLimited;
      case PermissionStatus.provisional:
        return l10n.permissionStatusProvisional;
      case PermissionStatus.permanentlyDenied:
        return l10n.permissionStatusPermanentlyDenied;
      default:
        return l10n.permissionStatusUnknown;
    }
  }

  VoidCallback? _wrapAsync(Future<void> Function()? callback) {
    if (callback == null) {
      return null;
    }
    return () {
      unawaited(callback());
    };
  }
}

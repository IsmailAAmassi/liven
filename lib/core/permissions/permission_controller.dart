import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../l10n/app_localizations.dart';
import '../services/permission_service.dart';
import '../widgets/permission_dialogs.dart';
import 'app_permission.dart';

class PermissionController {
  PermissionController({required PermissionService service}) : _service = service;

  final PermissionService _service;

  Future<bool> requestNotificationOnLaunch(BuildContext context) async {
    if (kIsWeb) {
      return true;
    }

    var status = await _service.getNotificationStatus();
    if (_isGranted(status)) {
      return true;
    }

    if (await _service.hasDismissedNotificationPrompt()) {
      return false;
    }

    return ensurePermission(
      context,
      AppPermission.notifications,
      trackDismissal: true,
    );
  }

  Future<bool> ensurePermission(
    BuildContext context,
    AppPermission permission, {
    bool trackDismissal = false,
  }) async {
    if (kIsWeb) {
      return true;
    }

    var status = await _statusFor(permission);
    if (_isGranted(status)) {
      return true;
    }

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPermissionDialog(
      context: context,
      title: permission.dialogTitle(l10n),
      description: permission.dialogDescription(l10n),
      confirmLabel: l10n.permissionActionAllow,
      cancelLabel: l10n.permissionActionNotNow,
    );

    if (confirmed != true) {
      if (permission == AppPermission.notifications && trackDismissal) {
        await _service.setNotificationPromptDismissed(true);
      }
      return false;
    }

    status = await _requestPermission(permission);
    final granted = await _handleRequestLoop(context, permission, status);

    if (permission == AppPermission.notifications && granted) {
      await _service.setNotificationPromptDismissed(true);
    }

    return granted;
  }

  Future<Map<AppPermission, PermissionStatus>> loadAllStatuses() async {
    if (kIsWeb) {
      return {
        for (final permission in AppPermission.values) permission: PermissionStatus.granted,
      };
    }

    return {
      AppPermission.notifications: await _service.getNotificationStatus(),
      AppPermission.storage: await _service.getStorageStatus(),
      AppPermission.camera: await _service.getCameraStatus(),
    };
  }

  Future<bool> openSettings() {
    return _service.openSystemSettings();
  }

  bool _isGranted(PermissionStatus status) {
    return status == PermissionStatus.granted ||
        status == PermissionStatus.limited ||
        status == PermissionStatus.provisional;
  }

  bool _requiresSettings(PermissionStatus status) {
    return status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted;
  }

  Future<PermissionStatus> _statusFor(AppPermission permission) {
    switch (permission) {
      case AppPermission.notifications:
        return _service.getNotificationStatus();
      case AppPermission.storage:
        return _service.getStorageStatus();
      case AppPermission.camera:
        return _service.getCameraStatus();
    }
  }

  Future<PermissionStatus> _requestPermission(AppPermission permission) {
    switch (permission) {
      case AppPermission.notifications:
        return _service.requestNotificationPermission();
      case AppPermission.storage:
        return _service.requestStoragePermission();
      case AppPermission.camera:
        return _service.requestCameraPermission();
    }
  }

  Future<bool> _handleRequestLoop(
    BuildContext context,
    AppPermission permission,
    PermissionStatus status,
  ) async {
    var currentStatus = status;
    final l10n = AppLocalizations.of(context)!;

    while (!_isGranted(currentStatus)) {
      if (_requiresSettings(currentStatus)) {
        final goToSettings = await showPermissionSettingsDialog(
          context: context,
          title: l10n.permissionSettingsDialogTitle,
          description: l10n.permissionSettingsDialogDescription(permission.title(l10n)),
          confirmLabel: l10n.permissionActionGoToSettings,
          cancelLabel: l10n.permissionActionLater,
        );

        if (goToSettings == true) {
          await _service.openSystemSettings();
          await Future.delayed(const Duration(milliseconds: 400));
          currentStatus = await _statusFor(permission);
          continue;
        }

        return false;
      }

      final retry = await showPermissionDialog(
        context: context,
        title: l10n.permissionDeniedDialogTitle,
        description: l10n.permissionDeniedDialogDescription(permission.title(l10n)),
        confirmLabel: l10n.permissionActionRetry,
        cancelLabel: l10n.permissionActionLater,
      );

      if (retry == true) {
        currentStatus = await _requestPermission(permission);
        continue;
      }

      return false;
    }

    return true;
  }
}

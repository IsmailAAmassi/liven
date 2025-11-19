import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

enum AppPermission {
  notifications,
  storage,
  camera,
}

extension AppPermissionX on AppPermission {
  String title(AppLocalizations l10n) {
    switch (this) {
      case AppPermission.notifications:
        return l10n.permissionNotificationsName;
      case AppPermission.storage:
        return l10n.permissionStorageName;
      case AppPermission.camera:
        return l10n.permissionCameraName;
    }
  }

  String dialogTitle(AppLocalizations l10n) {
    switch (this) {
      case AppPermission.notifications:
        return l10n.permissionNotificationsDialogTitle;
      case AppPermission.storage:
        return l10n.permissionStorageDialogTitle;
      case AppPermission.camera:
        return l10n.permissionCameraDialogTitle;
    }
  }

  String dialogDescription(AppLocalizations l10n) {
    switch (this) {
      case AppPermission.notifications:
        return l10n.permissionNotificationsDialogDescription;
      case AppPermission.storage:
        return l10n.permissionStorageDialogDescription;
      case AppPermission.camera:
        return l10n.permissionCameraDialogDescription;
    }
  }

  String statusDescription(AppLocalizations l10n) {
    switch (this) {
      case AppPermission.notifications:
        return l10n.permissionNotificationsStatusDescription;
      case AppPermission.storage:
        return l10n.permissionStorageStatusDescription;
      case AppPermission.camera:
        return l10n.permissionCameraStatusDescription;
    }
  }

  IconData get icon {
    switch (this) {
      case AppPermission.notifications:
        return Icons.notifications_active_outlined;
      case AppPermission.storage:
        return Icons.folder_outlined;
      case AppPermission.camera:
        return Icons.camera_alt_outlined;
    }
  }
}

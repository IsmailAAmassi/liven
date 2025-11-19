import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import 'local_storage_service.dart';

class PermissionService {
  PermissionService({required LocalStorageService storage}) : _storage = storage;

  final LocalStorageService _storage;

  Permission get _storagePermission {
    if (kIsWeb) {
      return Permission.storage;
    }
    if (Platform.isIOS) {
      return Permission.photos;
    }
    return Permission.storage;
  }

  Future<PermissionStatus> requestNotificationPermission() async {
    if (kIsWeb) {
      return PermissionStatus.granted;
    }
    return Permission.notification.request();
  }

  Future<PermissionStatus> requestStoragePermission() async {
    if (kIsWeb) {
      return PermissionStatus.granted;
    }
    return _storagePermission.request();
  }

  Future<PermissionStatus> requestCameraPermission() async {
    if (kIsWeb) {
      return PermissionStatus.granted;
    }
    return Permission.camera.request();
  }

  Future<PermissionStatus> getNotificationStatus() async {
    if (kIsWeb) {
      return PermissionStatus.granted;
    }
    return Permission.notification.status;
  }

  Future<PermissionStatus> getStorageStatus() async {
    if (kIsWeb) {
      return PermissionStatus.granted;
    }
    return _storagePermission.status;
  }

  Future<PermissionStatus> getCameraStatus() async {
    if (kIsWeb) {
      return PermissionStatus.granted;
    }
    return Permission.camera.status;
  }

  Future<bool> hasDismissedNotificationPrompt() async {
    return _storage.hasDismissedNotificationPrompt();
  }

  Future<void> setNotificationPromptDismissed(bool value) {
    return _storage.setNotificationPromptDismissed(value);
  }

  Future<bool> openSystemSettings() async {
    if (kIsWeb) {
      return false;
    }
    return openAppSettings();
  }
}

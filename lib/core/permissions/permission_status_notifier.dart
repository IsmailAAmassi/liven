import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/permission_service.dart';
import 'app_permission.dart';

class PermissionStatusesNotifier
    extends StateNotifier<AsyncValue<Map<AppPermission, PermissionStatus>>> {
  PermissionStatusesNotifier(this._service)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final PermissionService _service;

  Future<void> refresh() => _load();

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return {
        AppPermission.notifications: await _service.getNotificationStatus(),
        AppPermission.storage: await _service.getStorageStatus(),
        AppPermission.camera: await _service.getCameraStatus(),
      };
    });
  }
}

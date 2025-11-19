import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_videosdk/flutter_zoom_videosdk.dart';

import '../config/zoom_config.dart';

final zoomConfigProvider = Provider<ZoomConfig>((ref) {
  return ZoomConfig.fromEnvironment();
});

final zoomMeetingPresetProvider = Provider<ZoomMeetingPreset>((ref) {
  return ZoomMeetingPreset.fromEnvironment();
});

final zoomServiceProvider = Provider<ZoomService>((ref) {
  final config = ref.watch(zoomConfigProvider);
  return ZoomService(config: config);
});

final zoomMeetingControllerProvider =
    StateNotifierProvider<ZoomMeetingController, AsyncValue<void>>((ref) {
  final service = ref.watch(zoomServiceProvider);
  final preset = ref.watch(zoomMeetingPresetProvider);
  return ZoomMeetingController(service: service, preset: preset);
});

class ZoomService {
  ZoomService({
    required ZoomConfig config,
    ZoomVideoSdk? sdk,
  })  : _config = config,
        _sdk = sdk ?? ZoomVideoSdk();

  final ZoomConfig _config;
  final ZoomVideoSdk _sdk;
  bool _initialized = false;
  ZoomInitializationException? _initializationException;

  bool get isInitialized => _initialized;
  bool get hasInitializationError => _initializationException != null;
  ZoomInitializationException? get initializationError => _initializationException;

  Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }

    if (_initializationException != null) {
      throw _initializationException!;
    }

    try {
      await _sdk.initialize(
        domain: _config.domain,
        enableLog: _config.enableLogs,
        logFilePrefix: _config.logFilePrefix,
      );
      _initialized = true;
    } on PlatformException catch (error, stackTrace) {
      _initializationException = ZoomInitializationException(
        error.message ?? 'Failed to initialize Zoom SDK',
        stackTrace,
      );
      throw _initializationException!;
    } catch (error, stackTrace) {
      _initializationException = ZoomInitializationException(
        error.toString(),
        stackTrace,
      );
      throw _initializationException!;
    }
  }

  Future<void> joinMeeting(ZoomMeetingPreset meeting) async {
    await ensureInitialized();

    if (!meeting.isConfigured) {
      throw const ZoomConfigurationException('Missing meeting credentials.');
    }

    try {
      await _sdk.joinSession(
        sessionName: meeting.sessionName,
        token: meeting.token,
        userName: meeting.userName,
        sessionPassword: meeting.password,
      );
    } on PlatformException catch (error, stackTrace) {
      throw ZoomJoinException(error.message ?? 'Failed to start Zoom session', stackTrace);
    }
  }
}

class ZoomMeetingController extends StateNotifier<AsyncValue<void>> {
  ZoomMeetingController({
    required ZoomService service,
    required ZoomMeetingPreset preset,
  })  : _service = service,
        preset = preset,
        super(const AsyncValue.data(null));

  final ZoomService _service;
  final ZoomMeetingPreset preset;

  bool get canJoinPreset => preset.isConfigured;

  Future<void> joinPresetMeeting() async {
    if (!preset.isConfigured) {
      state = AsyncValue.error(
        const ZoomConfigurationException('Missing meeting credentials'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.joinMeeting(preset));
  }
}

class ZoomConfigurationException implements Exception {
  const ZoomConfigurationException(this.message);
  final String message;

  @override
  String toString() => 'ZoomConfigurationException: $message';
}

class ZoomJoinException implements Exception {
  const ZoomJoinException(this.message, this.stackTrace);
  final String message;
  final StackTrace stackTrace;

  @override
  String toString() => 'ZoomJoinException: $message';
}

class ZoomInitializationException implements Exception {
  const ZoomInitializationException(this.message, this.stackTrace);

  final String message;
  final StackTrace stackTrace;

  @override
  String toString() => 'ZoomInitializationException: $message';
}

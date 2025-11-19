import 'package:flutter/foundation.dart';

/// Shared configuration for the Zoom Video SDK integration.
@immutable
class ZoomConfig {
  const ZoomConfig({
    required this.domain,
    this.enableLogs = true,
    this.logFilePrefix = 'liven_zoom',
  });

  factory ZoomConfig.fromEnvironment() {
    return ZoomConfig(
      domain: const String.fromEnvironment('ZOOM_SDK_DOMAIN', defaultValue: 'zoom.us'),
      enableLogs: const bool.fromEnvironment('ZOOM_SDK_ENABLE_LOGS', defaultValue: true),
      logFilePrefix:
          const String.fromEnvironment('ZOOM_SDK_LOG_PREFIX', defaultValue: 'liven_zoom'),
    );
  }

  final String domain;
  final bool enableLogs;
  final String logFilePrefix;
}

/// Convenience holder for session-level credentials that can be injected
/// at runtime via `--dart-define` or a remote config service.
@immutable
class ZoomMeetingPreset {
  const ZoomMeetingPreset({
    required this.sessionName,
    required this.userName,
    required this.token,
    this.password = '',
  });

  factory ZoomMeetingPreset.fromEnvironment() {
    return ZoomMeetingPreset(
      sessionName: const String.fromEnvironment('ZOOM_SESSION_NAME', defaultValue: ''),
      userName: const String.fromEnvironment('ZOOM_SESSION_USERNAME', defaultValue: ''),
      token: const String.fromEnvironment('ZOOM_SESSION_TOKEN', defaultValue: ''),
      password: const String.fromEnvironment('ZOOM_SESSION_PASSWORD', defaultValue: ''),
    );
  }

  final String sessionName;
  final String userName;
  final String token;
  final String password;

  bool get isConfigured =>
      sessionName.isNotEmpty && userName.isNotEmpty && token.isNotEmpty;
}

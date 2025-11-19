import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:liven/firebase_options.dart';
import 'auth_storage.dart';

typedef NotificationTapHandler = FutureOr<void> Function(RemoteMessage message);

class FcmService {
  FcmService({
    required AuthStorage storage,
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _storage = storage,
        _messaging = messaging ?? FirebaseMessaging.instance,
        _localNotifications = localNotifications ?? _sharedNotificationsPlugin;

  final AuthStorage _storage;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  static final FlutterLocalNotificationsPlugin _sharedNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    'liven_default_channel',
    'Liven notifications',
    description: 'Used for Liven foreground and background notifications.',
    importance: Importance.high,
  );

  static bool _localNotificationsInitialized = false;
  static bool _backgroundHandlerRegistered = false;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _tapSubscription;
  NotificationTapHandler? _tapHandler;
  bool _initialized = false;
  bool _foregroundHandlersRegistered = false;

  Future<void> initialize({NotificationTapHandler? onNotificationTap}) async {
    if (_initialized || kIsWeb) {
      _tapHandler = onNotificationTap;
      return;
    }

    _initialized = true;
    _tapHandler = onNotificationTap;

    await _ensureFirebaseInitialized();
    await _configureLocalNotifications();
    await _requestPermissions();
    await _cacheInitialToken();
    _listenToTokenRefresh();

    handleForegroundMessages();
    handleBackgroundMessages();

    await _handleInitialMessage();
  }

  Future<String?> getToken({bool forceRefresh = false}) async {
    if (kIsWeb) {
      return null;
    }

    if (!forceRefresh) {
      final cached = await _storage.getDeviceFcmToken();
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
    }

    final token = await _messaging.getToken();
    if (token != null) {
      await _storage.saveDeviceFcmToken(token);
      await _syncWithBackendIfNeeded(token);
    }
    return token;
  }

  Stream<String> onTokenRefresh() {
    if (kIsWeb) {
      return const Stream.empty();
    }
    return _messaging.onTokenRefresh;
  }

  void handleForegroundMessages() {
    if (kIsWeb || _foregroundHandlersRegistered) {
      return;
    }
    _foregroundHandlersRegistered = true;

    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) async {
      await _showLocalNotification(message);
    });

    _tapSubscription = FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  void handleBackgroundMessages() {
    registerBackgroundHandler();
  }

  static void registerBackgroundHandler() {
    if (kIsWeb || _backgroundHandlerRegistered) {
      return;
    }
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    _backgroundHandlerRegistered = true;
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundSubscription?.cancel();
    await _tapSubscription?.cancel();
  }

  Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  Future<void> _configureLocalNotifications() async {
    if (kIsWeb) {
      return;
    }

    await ensureLocalNotificationsInitialized();

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> ensureLocalNotificationsInitialized() async {
    if (_localNotificationsInitialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _sharedNotificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
    await _sharedNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
    _localNotificationsInitialized = true;
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) {
      return;
    }

    final settings = await _messaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.denied ||
        settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

  Future<void> _cacheInitialToken() async {
    await getToken();
  }

  void _listenToTokenRefresh() {
    if (kIsWeb) {
      return;
    }
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((token) async {
      await _storage.saveDeviceFcmToken(token);
      await _syncWithBackendIfNeeded(token);
    });
  }

  Future<void> _syncWithBackendIfNeeded(String token) async {
    final authToken = await _storage.getToken();
    if (authToken == null || authToken.isEmpty) {
      return;
    }

    final backendToken = await _storage.getBackendFcmToken();
    if (backendToken == token) {
      return;
    }

    await updateBackendToken(token);
  }

  Future<void> updateBackendToken(String token) async {
    debugPrint('Syncing FCM token with backend (placeholder): $token');
    await _storage.saveBackendFcmToken(token);
  }

  Future<void> _handleInitialMessage() async {
    if (kIsWeb) {
      return;
    }
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleNotificationTap(initialMessage);
    }
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    if (_tapHandler != null) {
      await _tapHandler!(message);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    if (kIsWeb) {
      return;
    }

    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;

    if (title == null && body == null) {
      return;
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        icon: notification?.android?.smallIcon ?? '@mipmap/ic_launcher',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotifications.show(
      notification.hashCode,
      title,
      body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  static Future<void> showBackgroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;

    if (title == null && body == null) {
      return;
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        icon: notification?.android?.smallIcon ?? '@mipmap/ic_launcher',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _sharedNotificationsPlugin.show(
      notification.hashCode,
      title,
      body,
      details,
      payload: jsonEncode(message.data),
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmService.ensureLocalNotificationsInitialized();
  await FcmService.showBackgroundNotification(message);
}

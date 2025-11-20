import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import '../services/auth_storage.dart';
import '../services/local_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required AuthStorage storage}) : _storage = storage;

  final AuthStorage _storage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor({
    required LocalStorageService storage,
    this.appVersion,
    this.deviceInfo,
  }) : _storage = storage;

  final LocalStorageService _storage;
  final String? appVersion;
  final String? deviceInfo;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final locale = await _storage.getLocale();
    options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-App-Platform': 'flutter',
      'X-App-Version': appVersion ?? '1.0.0',
      'X-Device-Info': deviceInfo ?? 'unknown',
      'Accept-Language': locale.languageCode,
    });
    options.baseUrl = AppConfig.baseUrl;
    handler.next(options);
  }
}

Interceptor loggingInterceptor() {
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 120,
    enabled: kDebugMode,
  );
}

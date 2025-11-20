import 'dart:async';
import 'dart:io';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/services/auth_storage.dart';
import '../../../../core/utils/unit.dart';
import '../../domain/entities/user.dart';
import '../../domain/models/auth_result.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/register_result.dart';
import '../../domain/repositories/auth_repository.dart';

class RealAuthService implements AuthRepository {
  RealAuthService({
    required ApiClient apiClient,
    required AuthStorage storage,
    required ApiErrorMapper errorMapper,
  })  : _apiClient = apiClient,
        _storage = storage,
        _errorMapper = errorMapper;

  final ApiClient _apiClient;
  final AuthStorage _storage;
  final ApiErrorMapper _errorMapper;

  @override
  Future<AuthResult> login({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final response = await _apiClient.post(_loginPath, body: {
        'phone': phone,
        'password': password,
        if (fcmToken != null) 'fcm_token': fcmToken,
      });
      if (response.isSuccessful) {
        return await _handleLoginSuccess(response.data);
      }
      if (response.statusCode == 422) {
        final message = _extractMessage(response.data);
        return ApiError(
          ApiFailure(
            statusCode: response.statusCode,
            messageKey: 'auth_invalid_credentials',
            details: {'message': message},
          ),
        );
      }
      return ApiError(_errorMapper.map(response.statusCode, response.data));
    } on SocketException catch (_) {
      return const ApiError(ApiFailure(messageKey: 'error_network'));
    } on TimeoutException catch (_) {
      return const ApiError(ApiFailure(messageKey: 'error_network'));
    } catch (_) {
      return const ApiError(ApiFailure(messageKey: 'auth_login_failed'));
    }
  }

  @override
  Future<RegisterResult> register({
    required String phone,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _apiClient.post(_registerPath, body: {
        'phone': phone,
        'password': password,
        'name': name,
      });
      if (response.isSuccessful) {
        final payload = _parsePayload(response.data);
        final status = payload['status'] == true;
        if (status) {
          return RegisterResult.success(message: payload['message'] as String?);
        }
        return RegisterResult.failure(
          message: payload['message'] as String?,
          messageKey: 'auth_register_failed',
        );
      }
      if (response.statusCode == 422) {
        final errors = _parseErrors(response.data);
        return RegisterResult.failure(
          errors: errors,
          message: _extractMessage(response.data),
          messageKey: 'error_validation',
        );
      }
      final failure = _errorMapper.map(response.statusCode, response.data);
      return RegisterResult.failure(
        message: failure.details?['message'] as String?,
        messageKey: failure.messageKey,
      );
    } on SocketException catch (_) {
      return const RegisterResult.failure(messageKey: 'error_network');
    } on TimeoutException catch (_) {
      return const RegisterResult.failure(messageKey: 'error_network');
    } catch (_) {
      return const RegisterResult.failure(messageKey: 'auth_register_failed');
    }
  }

  @override
  Future<EmptyResult> requestPasswordReset(String identifier) async {
    final response = await _apiClient.post(
      _sendOtpPath,
      body: _identifierPayload(identifier),
    );
    return _handleEmptyResult(response);
  }

  @override
  Future<EmptyResult> verifyOtp(String code) async {
    final response = await _apiClient.post(_verifyOtpPath, body: {
      'code': code,
    });
    return _handleEmptyResult(response);
  }

  @override
  Future<EmptyResult> resetPassword({
    required String identifier,
    required String password,
  }) async {
    final payload = _identifierPayload(identifier)
      ..['password'] = password;
    final response = await _apiClient.post(_resetPasswordPath, body: payload);
    return _handleEmptyResult(response);
  }

  @override
  Future<EmptyResult> logout() async {
    final response = await _apiClient.post(_logoutPath);
    if (response.isSuccessful) {
      await _storage.clear();
    }
    return _handleEmptyResult(response);
  }

  @override
  Future<AuthResult> refreshToken() async {
    final response = await _apiClient.post(_refreshPath);
    if (response.isSuccessful) {
      return await _handleAuthSuccess(response.data);
    }
    return ApiError(_errorMapper.map(response.statusCode, response.data));
  }

  @override
  Future<User?> getCurrentUser() {
    return _storage.getUser();
  }

  @override
  Future<void> clearAuth() {
    return _storage.clear();
  }

  Future<AuthResult> _handleLoginSuccess(dynamic data) async {
    final payload = _parsePayload(data);
    final token = payload['token']?.toString() ?? '';
    final userId = _parseId(payload);
    final profileCompleted = payload['profile_completed'] as bool? ?? true;
    final session = AuthSession(
      token: token,
      userId: userId,
      profileCompleted: profileCompleted,
    );
    await _storage.saveAuthToken(token);
    await _storage.saveUserId(userId);
    return ApiSuccess(session);
  }

  Future<AuthResult> _handleAuthSuccess(dynamic data) async {
    final payload = _parsePayload(data);
    final token = payload['token']?.toString() ?? '';
    final userJson = _parseUser(payload);
    final user = User.fromJson(userJson);
    final session = AuthSession(
      token: token,
      userId: _parseId(payload, fallbackUser: user),
      profileCompleted: payload['profile_completed'] as bool? ?? true,
    );
    await _storage.saveAuthToken(token);
    await _storage.saveUserId(session.userId);
    await _storage.saveUser(user);
    return ApiSuccess(session);
  }

  Future<EmptyResult> _handleEmptyResult(ApiClientResponse response) async {
    if (response.isSuccessful) {
      return const ApiSuccess(Unit.instance);
    }
    return ApiError(_errorMapper.map(response.statusCode, response.data));
  }

  Map<String, dynamic> _parsePayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    return <String, dynamic>{};
  }

  List<String> _parseErrors(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is List) {
        return errors.whereType<String>().toList();
      }
    }
    return const [];
  }

  Map<String, dynamic> _parseUser(Map<String, dynamic> payload) {
    final raw = payload['user'];
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    return <String, dynamic>{};
  }

  Map<String, dynamic> _identifierPayload(String identifier) {
    final payload = <String, dynamic>{
      'identifier': identifier,
    };
    if (identifier.contains('@')) {
      payload['email'] = identifier;
    } else {
      payload['phone'] = identifier;
    }
    return payload;
  }

  int _parseId(Map<String, dynamic> payload, {User? fallbackUser}) {
    final rawId = payload['id'] ?? payload['user_id'] ?? fallbackUser?.id;
    if (rawId is int) {
      return rawId;
    }
    return int.tryParse(rawId?.toString() ?? '') ?? 0;
  }

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return '';
  }

  String get _loginPath => '/mobile/login';
  String get _registerPath => '/mobile/register';
  String get _sendOtpPath => '/mobile/user/otp/send';
  String get _verifyOtpPath => '/mobile/user/otp/verify';
  String get _resetPasswordPath => '/mobile/user/password/forget/update';
  String get _logoutPath => '/mobile/logout';
  String get _refreshPath => '/mobile/token/refresh';
}

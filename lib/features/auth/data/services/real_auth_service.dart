import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/services/auth_storage.dart';
import '../../../../core/utils/unit.dart';
import '../../domain/entities/user.dart';
import '../../domain/models/auth_result.dart';
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
    required String identifier,
    required String password,
    String? fcmToken,
  }) async {
    final payload = _identifierPayload(identifier)
      ..['password'] = password
      ..addAll(_fcmPayload(await _resolveFcmToken(fcmToken)));
    final response = await _apiClient.post(_loginPath, body: payload);
    if (response.isSuccessful) {
      return await _handleAuthSuccess(response.data);
    }
    return ApiError(_errorMapper.map(response.statusCode, response.data));
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    final payload = {
      'name': name,
      'email': email,
      'password': password,
      ..._fcmPayload(await _resolveFcmToken(fcmToken)),
    };
    final response = await _apiClient.post(_registerPath, body: payload);
    if (response.isSuccessful) {
      return await _handleAuthSuccess(response.data);
    }
    return ApiError(_errorMapper.map(response.statusCode, response.data));
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

  Future<AuthResult> _handleAuthSuccess(dynamic data) async {
    final payload = _parsePayload(data);
    final token = payload['token'] as String? ?? '';
    final userJson = _parseUser(payload);
    final user = User.fromJson(userJson);
    await _storage.saveToken(token);
    await _storage.saveUser(user);
    final backendFcmToken = payload['fcm_token'] as String? ??
        payload['device_fcm_token'] as String? ??
        userJson['fcm_token'] as String?;
    if (backendFcmToken != null && backendFcmToken.isNotEmpty) {
      await _storage.saveBackendFcmToken(backendFcmToken);
    }
    return ApiSuccess(user);
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

  Future<String?> _resolveFcmToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      return token;
    }
    return _storage.getDeviceFcmToken();
  }

  Map<String, dynamic> _fcmPayload(String? token) {
    if (token == null || token.isEmpty) {
      return <String, dynamic>{};
    }
    return {'fcm_token': token};
  }

  String get _loginPath => '/mobile/login';
  String get _registerPath => '/mobile/register';
  String get _sendOtpPath => '/mobile/user/otp/send';
  String get _verifyOtpPath => '/mobile/user/otp/verify';
  String get _resetPasswordPath => '/mobile/user/password/forget/update';
  String get _logoutPath => '/mobile/logout';
  String get _refreshPath => '/mobile/token/refresh';
}

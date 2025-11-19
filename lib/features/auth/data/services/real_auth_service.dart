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
  }) async {
    final response = await _apiClient.post(_loginPath, body: {
      'identifier': identifier,
      'password': password,
    });
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
  }) async {
    final response = await _apiClient.post(_registerPath, body: {
      'name': name,
      'email': email,
      'password': password,
    });
    if (response.isSuccessful) {
      return await _handleAuthSuccess(response.data);
    }
    return ApiError(_errorMapper.map(response.statusCode, response.data));
  }

  @override
  Future<EmptyResult> requestPasswordReset(String identifier) async {
    final response = await _apiClient.post(_requestResetPath, body: {
      'identifier': identifier,
    });
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
    final response = await _apiClient.post(_resetPasswordPath, body: {
      'identifier': identifier,
      'password': password,
    });
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

  String get _loginPath => '/auth/login';
  String get _registerPath => '/auth/register';
  String get _requestResetPath => '/auth/password/reset-request';
  String get _verifyOtpPath => '/auth/otp/verify';
  String get _resetPasswordPath => '/auth/password/reset';
  String get _logoutPath => '/auth/logout';
  String get _refreshPath => '/auth/refresh';
}

import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/app_api.dart';
import '../../../../core/network/endpoint_constants.dart';
import '../../../../core/services/auth_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/models/auth_result.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/complete_profile_result.dart';
import '../../domain/models/forgot_password_result.dart';
import '../../domain/models/otp_send_result.dart';
import '../../domain/models/otp_verify_result.dart';
import '../../domain/models/register_result.dart';
import '../../domain/models/reset_password_result.dart';
import '../../domain/repositories/auth_repository.dart';

class RealAuthService implements AuthRepository {
  RealAuthService({
    required AppApi api,
    required AuthStorage storage,
  })  : _api = api,
        _storage = storage;

  final AppApi _api;
  final AuthStorage _storage;

  @override
  Future<AuthResult> login({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    final result = await _api.post<Map<String, dynamic>>(
      Endpoints.login,
      data: {
        'phone': phone,
        'password': password,
        if (fcmToken != null) 'fcm_token': fcmToken,
      },
      parser: _asMap,
    );

    return result.when(
      success: (payload) => _handleLoginSuccess(payload),
      failure: (error) {
        if (error is ValidationException) {
          return ApiError(
            ApiFailure(
              statusCode: error.statusCode,
              messageKey: 'auth_invalid_credentials',
              message: error.message,
              errors: error.errors,
            ),
          );
        }
        return ApiError(_asFailure(error, fallbackKey: 'auth_login_failed'));
      },
    );
  }

  @override
  Future<RegisterResult> register({
    required String phone,
    required String password,
    required String name,
  }) async {
    final result = await _api.post<Map<String, dynamic>>(
      Endpoints.register,
      data: {
        'phone': phone,
        'password': password,
        'name': name,
      },
      parser: _asMap,
    );

    return result.when(
      success: (payload) {
        final status = payload['status'] == true;
        if (status) {
          return RegisterResult.success(message: payload['message'] as String?);
        }
        final errors = _parseErrors(payload);
        return RegisterResult.failure(
          errors: errors.isEmpty ? null : errors,
          message: payload['message'] as String?,
          messageKey: 'auth_register_failed',
        );
      },
      failure: (error) {
        if (error is ValidationException) {
          return RegisterResult.failure(
            errors: error.errors,
            message: error.message,
            messageKey: error.messageKey,
          );
        }
        return RegisterResult.failure(
          message: _selectMessage(error),
          messageKey: error.messageKey,
        );
      },
    );
  }

  @override
  Future<OtpVerifyResult> verifyOtp({
    required String phone,
    required String otpCode,
  }) async {
    final result = await _api.post<Map<String, dynamic>>(
      Endpoints.verifyOtp,
      data: {
        'phone': phone,
        'otp_code': otpCode,
      },
      parser: _asMap,
    );

    return result.when(
      success: (payload) async {
        final status = payload['status'] == true;
        if (status) {
          final token = _parseToken(payload);
          final userId = _parseId(payload);
          final profileCompleted = payload['profile_completed'] as bool? ?? true;
          final parsedPhone = _parsePhone(payload['data'], fallback: phone);
          await _storage.saveAuthToken(token);
          await _storage.saveUserId(userId);
          await _storage.saveUserPhone(parsedPhone);
          await _storage.saveProfileCompleted(profileCompleted);
          return OtpVerifyResult.success(
            userId: userId,
            token: token,
            phone: parsedPhone,
            profileCompleted: profileCompleted,
            message: payload['message'] as String?,
          );
        }
        final errors = _parseErrors(payload);
        return OtpVerifyResult.failure(
          message: payload['message'] as String?,
          errors: errors,
          messageKey: errors.isNotEmpty ? 'otp_required' : 'otp_invalid',
        );
      },
      failure: (error) {
        if (error is ValidationException) {
          final message = error.message ?? 'otp_generic_error';
          return OtpVerifyResult.failure(
            message: message,
            errors: error.errors,
            messageKey: error.fieldErrors?.isNotEmpty == true ? 'otp_required' : 'otp_generic_error',
          );
        }
        return OtpVerifyResult.failure(
          message: _selectMessage(error),
          messageKey: error.messageKey,
        );
      },
    );
  }

  @override
  Future<OtpSendResult> sendOtp({required String phone}) async {
    final result = await _api.post<Map<String, dynamic>>(
      Endpoints.sendOtp,
      data: {'phone': phone},
      parser: _asMap,
    );

    return result.when(
      success: (payload) {
        final status = payload['status'] == true;
        if (status) {
          return OtpSendResult.success(message: payload['message'] as String?);
        }
        return OtpSendResult.failure(
          message: payload['message'] as String?,
          messageKey: 'otp_generic_error',
        );
      },
      failure: (error) {
        if (error is ValidationException || error is BadRequestException) {
          return OtpSendResult.failure(
            message: error.message,
            errors: error.errors,
            messageKey: 'otp_generic_error',
          );
        }
        return OtpSendResult.failure(
          message: _selectMessage(error),
          messageKey: error.messageKey,
        );
      },
    );
  }

  @override
  Future<ForgotPasswordResult> forgotPassword({required String phone}) async {
    final result = await _api.post<Map<String, dynamic>>(
      Endpoints.forgotPassword,
      data: {'phone': phone},
      parser: _asMap,
    );

    return result.when(
      success: (payload) {
        final status = payload['status'] == true;
        if (status) {
          return ForgotPasswordResult.success(message: payload['message'] as String?);
        }
        final errors = _parseErrors(payload);
        return ForgotPasswordResult.failure(
          message: payload['message'] as String?,
          errors: errors,
          messageKey: errors.isNotEmpty ? 'error_validation' : 'otp_generic_error',
        );
      },
      failure: (error) {
        if (error is ValidationException || error is BadRequestException) {
          return ForgotPasswordResult.failure(
            message: error.message,
            errors: error.errors,
            messageKey: error.messageKey,
          );
        }
        return ForgotPasswordResult.failure(
          message: _selectMessage(error),
          messageKey: error.messageKey,
        );
      },
    );
  }

  @override
  Future<ResetPasswordResult> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final result = await _api.post<Map<String, dynamic>>(
      Endpoints.resetPassword,
      data: {
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      parser: _asMap,
    );

    return result.when(
      success: (payload) {
        final status = payload['status'] == true;
        if (status) {
          return ResetPasswordResult.success(message: payload['message'] as String?);
        }
        final errors = _parseErrors(payload);
        return ResetPasswordResult.failure(
          message: payload['message'] as String?,
          errors: errors,
          messageKey: 'error_validation',
        );
      },
      failure: (error) {
        if (error is ValidationException || error is BadRequestException) {
          return ResetPasswordResult.failure(
            message: error.message,
            errors: error.errors,
            messageKey: 'error_validation',
          );
        }
        return ResetPasswordResult.failure(
          message: _selectMessage(error),
          messageKey: error.messageKey,
        );
      },
    );
  }

  @override
  Future<void> logout() async {
    await _storage.clearAuth();
  }

  @override
  Future<AuthResult> refreshToken() async {
    final result = await _api.post<Map<String, dynamic>>(
      Endpoints.refreshToken,
      parser: _asMap,
    );

    return result.when(
      success: (payload) => _handleAuthSuccess(payload),
      failure: (error) => ApiError(_asFailure(error)),
    );
  }

  @override
  Future<CompleteProfileResult> completeProfile({
    required int age,
    required String gender,
    required int length,
    required int weight,
  }) async {
    final result = await _api.post<Map<String, dynamic>>(
      Endpoints.completeProfile,
      data: {
        'age': age,
        'gender': gender,
        'length': length,
        'weight': weight,
      },
      parser: _asMap,
    );

    return result.when(
      success: (payload) async {
        final status = payload['status'] == true;
        if (status) {
          final data = _parseData(payload);
          final token = _parseToken(payload);
          final userId = _parseId(payload, data: data);
          final storedPhone = await _storage.getUserPhone() ?? '';
          final phone = _parsePhone(data, fallback: storedPhone);

          await _storage.saveAuthToken(token);
          await _storage.saveUserId(userId);
          if (phone.isNotEmpty) {
            await _storage.saveUserPhone(phone);
          }
          await _storage.saveProfileCompleted(true);

          return CompleteProfileResult.success(
            message: payload['message'] as String?,
            userId: userId,
            token: token,
            phone: phone.isEmpty ? null : phone,
          );
        }
        final errors = _parseErrors(payload);
        return CompleteProfileResult.failure(
          message: payload['message'] as String?,
          errors: errors,
          fieldErrors: _mapFieldErrors(errors),
          messageKey: 'error_validation',
        );
      },
      failure: (error) {
        if (error is ValidationException) {
          final errors = error.errors ?? const [];
          return CompleteProfileResult.failure(
            message: error.message,
            errors: errors,
            messageKey: error.messageKey,
            fieldErrors: _mapFieldErrors(errors),
          );
        }
        return CompleteProfileResult.failure(
          message: _selectMessage(error),
          messageKey: error.messageKey,
        );
      },
    );
  }

  @override
  Future<User?> getCurrentUser() {
    return _storage.getUser();
  }

  @override
  Future<void> clearAuth() {
    return _storage.clearAuth();
  }

  Future<AuthResult> _handleLoginSuccess(Map<String, dynamic> payload) async {
    final token = _parseToken(payload);
    final userId = _parseId(payload);
    final profileCompleted = payload['profile_completed'] as bool? ?? true;
    await _storage.saveProfileCompleted(profileCompleted);
    final session = AuthSession(
      token: token,
      userId: userId,
      profileCompleted: profileCompleted,
    );
    await _storage.saveAuthToken(token);
    await _storage.saveUserId(userId);
    return ApiSuccess(session);
  }

  Future<AuthResult> _handleAuthSuccess(Map<String, dynamic> payload) async {
    final token = _parseToken(payload);
    final userJson = _parseUser(payload);
    final user = User.fromJson(userJson);
    final profileCompleted = payload['profile_completed'] as bool? ?? true;
    final session = AuthSession(
      token: token,
      userId: _parseId(payload, fallbackUser: user),
      profileCompleted: profileCompleted,
    );
    await _storage.saveAuthToken(token);
    await _storage.saveUserId(session.userId);
    await _storage.saveUser(user);
    await _storage.saveProfileCompleted(profileCompleted);
    return ApiSuccess(session);
  }

  Map<String, dynamic> _parseData(Map<String, dynamic> payload) {
    final raw = payload['data'];
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    return <String, dynamic>{};
  }

  String _parseToken(Map<String, dynamic> payload) {
    final token = payload['token']?.toString();
    final tempToken = payload['temp_token']?.toString();
    if (token != null && token.isNotEmpty) {
      return token;
    }
    return tempToken ?? '';
  }

  String _parsePhone(dynamic data, {String fallback = ''}) {
    String phone;
    if (data is Map<String, dynamic>) {
      final value = data['phone'] ?? data['tel'] ?? data['mobile'];
      phone = value?.toString() ?? '';
    } else {
      phone = data?.toString() ?? '';
    }
    if (phone.isEmpty) {
      phone = fallback;
    }
    if (phone.isNotEmpty && !phone.startsWith('0') && fallback.startsWith('0')) {
      phone = '0$phone';
    }
    return phone;
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

  int _parseId(
    Map<String, dynamic> payload, {
    User? fallbackUser,
    Map<String, dynamic>? data,
  }) {
    final rawId =
        data?['id'] ?? payload['id'] ?? payload['user_id'] ?? fallbackUser?.id;
    if (rawId is int) {
      return rawId;
    }
    return int.tryParse(rawId?.toString() ?? '') ?? 0;
  }

  Map<String, String> _mapFieldErrors(List<String> errors) {
    final fieldErrors = <String, String>{};
    for (final error in errors) {
      final normalized = error.toLowerCase();
      if (normalized.contains('age')) {
        fieldErrors['age'] = error;
      } else if (normalized.contains('gender')) {
        fieldErrors['gender'] = error;
      } else if (normalized.contains('weight')) {
        fieldErrors['weight'] = error;
      } else if (normalized.contains('length') || normalized.contains('height')) {
        fieldErrors['length'] = error;
      }
    }
    return fieldErrors;
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    return <String, dynamic>{};
  }

  ApiException _asFailure(ApiException error, {String? fallbackKey}) {
    if (fallbackKey != null && error is UnknownApiException) {
      return ApiFailure(messageKey: fallbackKey, message: error.message);
    }
    return error;
  }

  String? _selectMessage(ApiException error) {
    return error.message ?? error.messageEn ?? error.messageAr;
  }
}

import '../../../../core/network/api_result.dart';
import '../../../../core/services/auth_storage.dart';
import '../../../../core/utils/unit.dart';
import '../../domain/models/auth_result.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/otp_send_result.dart';
import '../../domain/models/otp_verify_result.dart';
import '../../domain/models/register_result.dart';
import '../../domain/repositories/auth_repository.dart';

class FakeAuthService implements AuthRepository {
  FakeAuthService({required AuthStorage storage}) : _storage = storage;

  final AuthStorage _storage;

  static const _token = 'fake-token';

  @override
  Future<AuthResult> login({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (phone.isEmpty || password.isEmpty) {
      return const ApiError(ApiFailure(messageKey: 'auth_invalid_credentials'));
    }
    final session = AuthSession(
      token: _token,
      userId: 1,
      profileCompleted: true,
    );
    await _persistSession(session);
    return ApiSuccess(session);
  }

  @override
  Future<RegisterResult> register({
    required String phone,
    required String password,
    required String name,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (phone == '0000000000') {
      return const RegisterResult.failure(
        errors: ['The phone has already been taken.'],
        messageKey: 'error_validation',
      );
    }
    if (name.isEmpty || phone.isEmpty || password.length < 6) {
      return const RegisterResult.failure(messageKey: 'errorInvalidRegistration');
    }
    return const RegisterResult.success(message: 'Registration successful');
  }

  @override
  Future<EmptyResult> requestPasswordReset(String identifier) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (identifier.isEmpty) {
      return const ApiError(ApiFailure(messageKey: 'errorIdentifierRequired'));
    }
    return const ApiSuccess(Unit.instance);
  }

  @override
  Future<OtpVerifyResult> verifyOtp({
    required String phone,
    required String otpCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (otpCode != '123456') {
      return const OtpVerifyResult.failure(messageKey: 'errorIncorrectOtp');
    }
    final session = AuthSession(
      token: _token,
      userId: 1,
      profileCompleted: true,
    );
    await _persistSession(session);
    await _storage.saveUserPhone(phone);
    await _storage.saveProfileCompleted(true);
    return const OtpVerifyResult.success(
      userId: 1,
      token: _token,
      phone: '0123456789',
      profileCompleted: true,
      message: 'success',
    );
  }

  @override
  Future<OtpSendResult> sendOtp({required String phone}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (phone.isEmpty) {
      return const OtpSendResult.failure(messageKey: 'otp_required');
    }
    return const OtpSendResult.success(message: 'OTP has been sent for your mobile');
  }

  @override
  Future<EmptyResult> resetPassword({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (identifier.isEmpty || password.length < 6) {
      return const ApiError(ApiFailure(messageKey: 'errorInvalidResetData'));
    }
    return const ApiSuccess(Unit.instance);
  }

  @override
  Future<EmptyResult> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _storage.clear();
    return const ApiSuccess(Unit.instance);
  }

  @override
  Future<AuthResult> refreshToken() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final id = await _storage.getUserId();
    if (id == null) {
      return const ApiError(ApiFailure(messageKey: 'error_unauthorized'));
    }
    final session = AuthSession(
      token: _token,
      userId: id,
      profileCompleted: true,
    );
    await _persistSession(session);
    return ApiSuccess(session);
  }

  @override
  Future<User?> getCurrentUser() {
    return _storage.getUser();
  }

  @override
  Future<void> clearAuth() {
    return _storage.clear();
  }

  Future<void> _persistSession(AuthSession session) async {
    await _storage.saveAuthToken(session.token);
    await _storage.saveUserId(session.userId);
    await _storage.saveProfileCompleted(session.profileCompleted);
  }
}

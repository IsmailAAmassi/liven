import 'package:liven/features/auth/domain/entities/user.dart';

import '../../../../core/network/api_result.dart';
import '../../../../core/services/auth_storage.dart';
import '../../domain/models/auth_result.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/forgot_password_result.dart';
import '../../domain/models/complete_profile_result.dart';
import '../../domain/models/otp_send_result.dart';
import '../../domain/models/otp_verify_result.dart';
import '../../domain/models/register_result.dart';
import '../../domain/models/reset_password_result.dart';
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
  Future<ForgotPasswordResult> forgotPassword({required String phone}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (phone.isEmpty) {
      return const ForgotPasswordResult.failure(messageKey: 'validationPhoneRequired');
    }
    return const ForgotPasswordResult.success(message: 'OTP has been sent to your mobile.');
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
  Future<ResetPasswordResult> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (phone.isEmpty) {
      return const ResetPasswordResult.failure(messageKey: 'validationPhoneRequired');
    }
    if (password.length < 6) {
      return const ResetPasswordResult.failure(
        errors: ['The password must be at least 6 characters.'],
        messageKey: 'error_validation',
      );
    }
    if (password != passwordConfirmation) {
      return const ResetPasswordResult.failure(
        errors: ['The password confirmation does not match.'],
        messageKey: 'error_validation',
      );
    }
    return const ResetPasswordResult.success(message: 'Password reset successfully.');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _storage.clearAuth();
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
    return _storage.clearAuth();
  }

  @override
  Future<CompleteProfileResult> completeProfile({
    required int age,
    required String gender,
    required int length,
    required int weight,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final session = AuthSession(
      token: _token,
      userId: 1,
      profileCompleted: true,
    );
    await _persistSession(session);
    return const CompleteProfileResult.success(
      message: 'Profile completed',
      userId: 1,
      token: _token,
      phone: '0123456789',
    );
  }

  Future<void> _persistSession(AuthSession session) async {
    await _storage.saveAuthToken(session.token);
    await _storage.saveUserId(session.userId);
    await _storage.saveProfileCompleted(session.profileCompleted);
  }
}

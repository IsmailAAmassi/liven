import '../../../../core/network/api_result.dart';
import '../entities/user.dart';
import '../models/auth_result.dart';
import '../models/otp_send_result.dart';
import '../models/otp_verify_result.dart';
import '../models/register_result.dart';

abstract interface class AuthRepository {
  Future<AuthResult> login({
    required String phone,
    required String password,
    String? fcmToken,
  });

  Future<RegisterResult> register({
    required String phone,
    required String password,
    required String name,
  });

  Future<EmptyResult> requestPasswordReset(String identifier);

  Future<OtpVerifyResult> verifyOtp({
    required String phone,
    required String otpCode,
  });

  Future<OtpSendResult> sendOtp({required String phone});

  Future<EmptyResult> resetPassword({
    required String identifier,
    required String password,
  });

  Future<EmptyResult> logout();

  Future<AuthResult> refreshToken();

  Future<User?> getCurrentUser();

  Future<void> clearAuth();
}

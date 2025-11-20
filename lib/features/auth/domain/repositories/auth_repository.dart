import '../../../../core/network/api_result.dart';
import '../entities/user.dart';
import '../models/auth_result.dart';
import '../models/otp_send_result.dart';
import '../models/otp_verify_result.dart';
import '../models/register_result.dart';
import '../models/forgot_password_result.dart';
import '../models/reset_password_result.dart';
import '../models/complete_profile_result.dart';

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

  Future<ForgotPasswordResult> forgotPassword({required String phone});

  Future<OtpVerifyResult> verifyOtp({
    required String phone,
    required String otpCode,
  });

  Future<OtpSendResult> sendOtp({required String phone});

  Future<ResetPasswordResult> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<EmptyResult> logout();

  Future<AuthResult> refreshToken();

  Future<User?> getCurrentUser();

  Future<void> clearAuth();

  Future<CompleteProfileResult> completeProfile({
    required int age,
    required String gender,
    required int length,
    required int weight,
  });
}

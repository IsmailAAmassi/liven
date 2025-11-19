import '../../../../core/network/api_result.dart';
import '../../../../core/utils/unit.dart';
import '../entities/user.dart';
import '../models/auth_result.dart';

abstract interface class AuthRepository {
  Future<AuthResult> login({
    required String identifier,
    required String password,
  });

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  });

  Future<EmptyResult> requestPasswordReset(String identifier);

  Future<EmptyResult> verifyOtp(String code);

  Future<EmptyResult> resetPassword({
    required String identifier,
    required String password,
  });

  Future<EmptyResult> logout();

  Future<AuthResult> refreshToken();

  Future<User?> getCurrentUser();

  Future<void> clearAuth();
}

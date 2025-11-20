import '../../../../core/network/api_result.dart';
import '../../../../core/services/auth_storage.dart';
import '../../../../core/utils/unit.dart';
import '../../domain/entities/user.dart';
import '../../domain/models/auth_result.dart';
import '../../domain/models/auth_session.dart';
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
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (name.isEmpty || email.isEmpty || password.length < 6) {
      return const ApiError(ApiFailure(messageKey: 'errorInvalidRegistration'));
    }
    final user = User(id: '2', name: name, email: email);
    final session = AuthSession(
      token: _token,
      userId: 2,
      profileCompleted: true,
    );
    await _persistUserSession(user, session);
    return ApiSuccess(session);
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
  Future<EmptyResult> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (code != '123456') {
      return const ApiError(ApiFailure(messageKey: 'errorIncorrectOtp'));
    }
    return const ApiSuccess(Unit.instance);
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
    await _storage.saveAuthToken(_token);
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
  }

  Future<void> _persistUserSession(User user, AuthSession session) async {
    await _persistSession(session);
    await _storage.saveUser(user);
  }
}

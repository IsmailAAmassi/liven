import '../../../../core/network/api_result.dart';
import '../../../../core/services/auth_storage.dart';
import '../../../../core/utils/unit.dart';
import '../../domain/entities/user.dart';
import '../../domain/models/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';

class FakeAuthService implements AuthRepository {
  FakeAuthService({required AuthStorage storage}) : _storage = storage;

  final AuthStorage _storage;

  static const _token = 'fake-token';

  @override
  Future<AuthResult> login({
    required String identifier,
    required String password,
    String? fcmToken,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (identifier.isEmpty || password.isEmpty) {
      return const ApiError(ApiFailure(messageKey: 'errorInvalidCredentials'));
    }
    final user = _buildUser(identifier: identifier);
    await _persistSession(user, backendFcmToken: fcmToken);
    return ApiSuccess(user);
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (name.isEmpty || email.isEmpty || password.length < 6) {
      return const ApiError(ApiFailure(messageKey: 'errorInvalidRegistration'));
    }
    final user = User(id: '2', name: name, email: email);
    await _persistSession(user, backendFcmToken: fcmToken);
    return ApiSuccess(user);
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
    final user = await _storage.getUser();
    if (user == null) {
      return const ApiError(ApiFailure(messageKey: 'error_unauthorized'));
    }
    await _storage.saveToken(_token);
    return ApiSuccess(user);
  }

  @override
  Future<User?> getCurrentUser() {
    return _storage.getUser();
  }

  @override
  Future<void> clearAuth() {
    return _storage.clear();
  }

  User _buildUser({required String identifier}) {
    final email = identifier.contains('@') ? identifier : 'user@liven.app';
    return User(
      id: '1',
      name: 'Demo User',
      email: email,
    );
  }

  Future<void> _persistSession(User user, {String? backendFcmToken}) async {
    await _storage.saveToken(_token);
    await _storage.saveUser(user);
    if (backendFcmToken != null && backendFcmToken.isNotEmpty) {
      await _storage.saveBackendFcmToken(backendFcmToken);
    }
  }
}

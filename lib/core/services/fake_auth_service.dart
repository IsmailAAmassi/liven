class FakeAuthService {
  Future<void> login({required String identifier, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (identifier.isEmpty || password.isEmpty) {
      throw const FakeAuthException(FakeAuthError.invalidCredentials);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (name.isEmpty || email.isEmpty || password.length < 6) {
      throw const FakeAuthException(FakeAuthError.invalidRegistration);
    }
  }

  Future<void> requestPasswordReset(String identifier) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (identifier.isEmpty) {
      throw const FakeAuthException(FakeAuthError.identifierRequired);
    }
  }

  Future<void> resetPassword({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (identifier.isEmpty || password.length < 6) {
      throw const FakeAuthException(FakeAuthError.invalidResetData);
    }
  }

  Future<void> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (code != '123456') {
      throw const FakeAuthException(FakeAuthError.incorrectOtp);
    }
  }
}

enum FakeAuthError {
  invalidCredentials,
  invalidRegistration,
  identifierRequired,
  invalidResetData,
  incorrectOtp,
}

class FakeAuthException implements Exception {
  const FakeAuthException(this.error);

  final FakeAuthError error;

  @override
  String toString() => error.name;
}

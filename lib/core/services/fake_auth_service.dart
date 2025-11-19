class FakeAuthService {
  Future<void> login({required String identifier, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (identifier.isEmpty || password.isEmpty) {
      throw const FakeAuthException('Please enter valid credentials.');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (name.isEmpty || email.isEmpty || password.length < 6) {
      throw const FakeAuthException('Please provide valid registration data.');
    }
  }

  Future<void> requestPasswordReset(String identifier) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (identifier.isEmpty) {
      throw const FakeAuthException('Identifier is required.');
    }
  }

  Future<void> resetPassword({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (identifier.isEmpty || password.length < 6) {
      throw const FakeAuthException('Invalid reset data.');
    }
  }

  Future<void> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (code != '123456') {
      throw const FakeAuthException('Incorrect OTP code.');
    }
  }
}

class FakeAuthException implements Exception {
  const FakeAuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

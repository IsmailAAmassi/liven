class AuthSession {
  const AuthSession({
    required this.token,
    required this.userId,
    required this.profileCompleted,
  });

  final String token;
  final int userId;
  final bool profileCompleted;
}

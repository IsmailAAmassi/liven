class RegisterResult {
  const RegisterResult._({
    required this.success,
    this.message,
    this.errors,
    this.messageKey,
  });

  const RegisterResult.success({String? message})
      : this._(success: true, message: message);

  const RegisterResult.failure({
    String? message,
    List<String>? errors,
    String? messageKey,
  }) : this._(
          success: false,
          message: message,
          errors: errors,
          messageKey: messageKey,
        );

  final bool success;
  final String? message;
  final List<String>? errors;
  final String? messageKey;

  bool get hasErrors => (errors?.isNotEmpty ?? false);
}

class CompleteProfileResult {
  const CompleteProfileResult._({
    required this.success,
    this.message,
    this.errors,
    this.fieldErrors,
    this.messageKey,
    this.userId,
    this.token,
    this.phone,
  });

  const CompleteProfileResult.success({
    String? message,
    int? userId,
    String? token,
    String? phone,
  }) : this._(
    success: true,
    message: message,
    userId: userId,
    token: token,
    phone: phone,
  );

  const CompleteProfileResult.failure({
    String? message,
    List<String>? errors,
    Map<String, String>? fieldErrors,
    String? messageKey,
  }) : this._(
    success: false,
    message: message,
    errors: errors,
    fieldErrors: fieldErrors,
    messageKey: messageKey,
  );

  final bool success;
  final String? message;
  final List<String>? errors;
  final Map<String, String>? fieldErrors;
  final String? messageKey;
  final int? userId;
  final String? token;
  final String? phone;

  bool get hasErrors =>
      (errors?.isNotEmpty ?? false) || (fieldErrors?.isNotEmpty ?? false);
}

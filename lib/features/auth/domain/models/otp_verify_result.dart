class OtpVerifyResult {
  const OtpVerifyResult._({
    required this.success,
    this.message,
    this.errors,
    this.messageKey,
    this.userId,
    this.token,
    this.phone,
    this.profileCompleted,
  });

  const OtpVerifyResult.success({
    required int userId,
    required String token,
    required String phone,
    required bool profileCompleted,
    String? message,
  }) : this._(
          success: true,
          userId: userId,
          token: token,
          phone: phone,
          profileCompleted: profileCompleted,
          message: message,
        );

  const OtpVerifyResult.failure({
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
  final int? userId;
  final String? token;
  final String? phone;
  final bool? profileCompleted;

  bool get hasErrors => (errors?.isNotEmpty ?? false);
}

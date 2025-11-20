abstract class ApiException implements Exception {
  const ApiException({
    this.statusCode,
    this.messageKey = 'error_unknown',
    this.message,
    this.messageAr,
    this.messageEn,
    this.errors,
    this.fieldErrors,
  });

  final int? statusCode;
  final String messageKey;
  final String? message;
  final String? messageAr;
  final String? messageEn;
  final List<String>? errors;
  final Map<String, List<String>>? fieldErrors;

  String? messageForLocale(String localeCode) {
    if (localeCode.startsWith('ar') && messageAr != null && messageAr!.isNotEmpty) {
      return messageAr;
    }
    if (localeCode.startsWith('en') && messageEn != null && messageEn!.isNotEmpty) {
      return messageEn;
    }
    return message;
  }
}

class NetworkException extends ApiException {
  const NetworkException({String messageKey = 'error_network', String? message})
      : super(messageKey: messageKey, message: message);
}

class TimeoutApiException extends ApiException {
  const TimeoutApiException({String messageKey = 'error_timeout', String? message})
      : super(messageKey: messageKey, message: message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({String? message})
      : super(statusCode: 401, messageKey: 'error_unauthorized', message: message);
}

class ForbiddenException extends ApiException {
  const ForbiddenException({String? message})
      : super(statusCode: 403, messageKey: 'error_forbidden', message: message);
}

class NotFoundException extends ApiException {
  const NotFoundException({String? message})
      : super(statusCode: 404, messageKey: 'error_not_found', message: message);
}

class ConflictException extends ApiException {
  const ConflictException({String? message})
      : super(statusCode: 409, messageKey: 'error_conflict', message: message);
}

class ValidationException extends ApiException {
  const ValidationException({
    int? statusCode,
    String messageKey = 'error_validation',
    String? message,
    List<String>? errors,
    Map<String, List<String>>? fieldErrors,
  }) : super(
          statusCode: statusCode ?? 422,
          messageKey: messageKey,
          message: message,
          errors: errors,
          fieldErrors: fieldErrors,
        );
}

class BadRequestException extends ApiException {
  const BadRequestException({int? statusCode = 400, String? message, List<String>? errors})
      : super(statusCode: statusCode, messageKey: 'error_bad_request', message: message, errors: errors);
}

class ServerException extends ApiException {
  const ServerException({int? statusCode, String? message})
      : super(statusCode: statusCode, messageKey: 'error_server', message: message);
}

class UnknownApiException extends ApiException {
  const UnknownApiException({int? statusCode, String? message})
      : super(statusCode: statusCode, messageKey: 'error_unknown', message: message);
}

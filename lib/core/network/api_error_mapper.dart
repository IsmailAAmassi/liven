import 'api_result.dart';

class ApiErrorMapper {
  const ApiErrorMapper();

  ApiFailure map(int? statusCode, dynamic body) {
    switch (statusCode) {
      case 400:
        return const ApiFailure(statusCode: 400, messageKey: 'error_bad_request');
      case 401:
        return const ApiFailure(statusCode: 401, messageKey: 'error_unauthorized');
      case 404:
        return const ApiFailure(statusCode: 404, messageKey: 'error_not_found');
      case 422:
        return const ApiFailure(statusCode: 422, messageKey: 'error_validation');
      default:
        if (statusCode != null && statusCode >= 500) {
          return ApiFailure(statusCode: statusCode, messageKey: 'error_server');
        }
        return const ApiFailure(messageKey: 'error_unknown');
    }
  }
}

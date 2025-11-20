import '../utils/unit.dart';
import 'api_exceptions.dart';

sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is ApiSuccess<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(ApiException error) failure,
  }) {
    if (this is ApiSuccess<T>) {
      return success((this as ApiSuccess<T>).data);
    }
    final error = this as ApiError<T>;
    return failure(error.error);
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);

  final T data;
}

class ApiError<T> extends ApiResult<T> {
  const ApiError(this.error);

  final ApiException error;
}

class ApiFailure extends ApiException {
  const ApiFailure({
    super.statusCode,
    super.messageKey = 'error_unknown',
    super.message,
    super.messageAr,
    super.messageEn,
    super.errors,
    super.fieldErrors,
  });
}

typedef EmptyResult = ApiResult<Unit>;

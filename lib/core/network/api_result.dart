import '../utils/unit.dart';

sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is ApiSuccess<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(ApiFailure failure) failure,
  }) {
    if (this is ApiSuccess<T>) {
      final result = this as ApiSuccess<T>;
      return success(result.data);
    }
    final error = this as ApiError<T>;
    return failure(error.failure);
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);

  final T data;
}

class ApiError<T> extends ApiResult<T> {
  const ApiError(this.failure);

  final ApiFailure failure;
}

class ApiFailure {
  const ApiFailure({
    this.statusCode,
    required this.messageKey,
    this.details,
  });

  final int? statusCode;
  final String messageKey;
  final Map<String, dynamic>? details;
}

typedef EmptyResult = ApiResult<Unit>;

import 'package:dio/dio.dart';

import 'api_exceptions.dart';
import 'api_response_parser.dart';
import 'api_result.dart';
import 'dio_client.dart';

class AppApi {
  AppApi(this._client);

  final DioClient _client;

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(dynamic data) parser,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _client.dio.get<dynamic>(path, queryParameters: query, cancelToken: cancelToken),
      parser,
    );
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    Map<String, dynamic>? query,
    Object? data,
    required T Function(dynamic data) parser,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _client.dio.post<dynamic>(path, data: data, queryParameters: query, cancelToken: cancelToken),
      parser,
    );
  }

  Future<ApiResult<T>> put<T>(
    String path, {
    Map<String, dynamic>? query,
    Object? data,
    required T Function(dynamic data) parser,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _client.dio.put<dynamic>(path, data: data, queryParameters: query, cancelToken: cancelToken),
      parser,
    );
  }

  Future<ApiResult<T>> delete<T>(
    String path, {
    Map<String, dynamic>? query,
    Object? data,
    required T Function(dynamic data) parser,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _client.dio.delete<dynamic>(path, data: data, queryParameters: query, cancelToken: cancelToken),
      parser,
    );
  }

  Future<ApiResult<T>> _request<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic data) parser,
  ) async {
    try {
      final response = await request();
      return ApiSuccess(parser(response.data));
    } on DioException catch (error) {
      return ApiError(_mapDioError(error));
    } catch (error) {
      return const ApiError(UnknownApiException());
    }
  }

  ApiException _mapDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const TimeoutApiException();
    }

    if (error.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final response = error.response;
    if (response == null) {
      return const UnknownApiException();
    }

    final parser = ApiResponseParser(response.data);
    final message = parser.message();
    final messageAr = parser.messageAr();
    final messageEn = parser.messageEn();
    final errors = parser.errors();
    final fieldErrors = parser.validationErrors();

    switch (response.statusCode) {
      case 400:
        return BadRequestException(
          statusCode: response.statusCode,
          message: message,
          errors: errors,
        );
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 409:
        return ConflictException(message: message);
      case 422:
        return ValidationException(
          statusCode: response.statusCode,
          message: message ?? messageEn ?? messageAr,
          errors: errors.isNotEmpty ? errors : null,
          fieldErrors: fieldErrors.isNotEmpty ? fieldErrors : null,
        );
      default:
        if (response.statusCode != null && response.statusCode! >= 500) {
          return ServerException(statusCode: response.statusCode, message: message);
        }
    }

    return UnknownApiException(
      statusCode: response.statusCode,
      message: message ?? messageEn ?? messageAr,
    );
  }
}

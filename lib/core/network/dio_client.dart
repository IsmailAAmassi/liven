import 'package:dio/dio.dart';

import 'dio_interceptors.dart';

class DioClient {
  DioClient({
    required AuthInterceptor authInterceptor,
    required HeaderInterceptor headerInterceptor,
    List<Interceptor> extraInterceptors = const [],
    BaseOptions? options,
  }) {
    dio = Dio(
      options ??
          BaseOptions(
            connectTimeout: const Duration(seconds: 25),
            receiveTimeout: const Duration(seconds: 25),
            sendTimeout: const Duration(seconds: 25),
            responseType: ResponseType.json,
            contentType: 'application/json',
          ),
    );

    dio.interceptors.addAll([
      headerInterceptor,
      authInterceptor,
      ...extraInterceptors,
      loggingInterceptor(),
    ]);
  }

  late final Dio dio;

  Dio copy({List<Interceptor>? interceptors}) {
    final cloned = Dio(BaseOptions.from(dio.options));
    cloned.interceptors.addAll(interceptors ?? dio.interceptors);
    return cloned;
  }
}

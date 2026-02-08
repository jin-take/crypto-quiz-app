import 'package:dio/dio.dart';
import '../../../config/app_config.dart';

class HttpClient {
  HttpClient._(this._dio);

  factory HttpClient.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.cdnBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {'Accept': 'application/json'},
      ),
    );

    if (AppConfig.enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: false,
          responseBody: false,
        ),
      );
    }

    return HttpClient._(dio);
  }

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    int maxRetries = 3,
  }) async {
    return _retry(() => _dio.get<T>(path, queryParameters: queryParameters),
        maxRetries: maxRetries);
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    int maxRetries = 3,
  }) async {
    return _retry(() => _dio.put<T>(path, data: data),
        maxRetries: maxRetries);
  }

  Future<Response<T>> _retry<T>(
    Future<Response<T>> Function() request, {
    required int maxRetries,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await request();
      } on DioException catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          rethrow;
        }
        final delay = Duration(seconds: 1 << (attempt - 1));
        await Future<void>.delayed(delay);
        if (AppConfig.enableLogging) {
          // ignore: avoid_print
          print('Retrying request (${attempt}/$maxRetries): ${e.message}');
        }
      }
    }
  }
}

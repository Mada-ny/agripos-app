import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../storage/token_storage.dart';

class DioClient {
  final Dio _dio;

  DioClient({
    required TokenStorage tokenStorage,
    required VoidCallback onUnauthorized,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: AppConstants.baseUrl,
           headers: const {'Accept': 'application/json'},
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
         ),
       ) {
    _dio.interceptors.add(
      _AuthInterceptor(
        tokenStorage: tokenStorage,
        onUnauthorized: onUnauthorized,
      ),
    );
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final VoidCallback _onUnauthorized;

  _AuthInterceptor({
    required TokenStorage tokenStorage,
    required VoidCallback onUnauthorized,
  }) : _tokenStorage = tokenStorage,
       _onUnauthorized = onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.readToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _onUnauthorized();
    }
    handler.next(err);
  }
}

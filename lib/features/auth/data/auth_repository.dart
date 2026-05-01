import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/models/user.dart';
import '../providers/auth_provider.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final DioClient _client;

  const AuthRepository(this._client);

  Future<(User, String)> login(String email, String password) async {
    try {
      final response = await _client.dio.post(
        '/api/v1/auth/login',
        data: {'email': email, 'password': password},
      );
      final payload = response.data['data'] as Map<String, dynamic>;
      final token = payload['token'] as String;
      final user = User.fromJson(payload['user'] as Map<String, dynamic>);
      return (user, token);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        final message = (data is Map && data['message'] is String)
            ? data['message'] as String
            : 'Login failed. Please try again.';
        final errors = (data is Map && data['errors'] is Map)
            ? Map<String, dynamic>.from(data['errors'] as Map)
            : null;
        throw AppException(
          message: message,
          statusCode: e.response!.statusCode,
          errors: errors,
        );
      }
      throw const AppException(
        message: 'Connection error. Check your network.',
      );
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _client.dio.post('/api/v1/auth/logout');
    } catch (_) {}
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(dioClientProvider));
}

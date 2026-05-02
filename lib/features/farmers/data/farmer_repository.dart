import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/errors/app_exception.dart';
import '../../../features/auth/providers/auth_provider.dart';
import 'debt.dart';
import 'farmer.dart';

part 'farmer_repository.g.dart';

class FarmerRepository {
  final DioClient _client;

  const FarmerRepository(this._client);

  Future<List<Farmer>> getFarmers({String? search}) async {
    try {
      final params = <String, dynamic>{};
      if (search != null && search.isNotEmpty) params['search'] = search;

      final first = await _client.dio.get(
        '/api/v1/farmers',
        queryParameters: params.isEmpty ? null : params,
      );
      final body = first.data as Map<String, dynamic>;
      final farmers = _parsePage(body['data'] as List);

      final lastPage =
          ((body['meta'] as Map<String, dynamic>?)?['last_page'] as int?) ?? 1;

      if (lastPage > 1) {
        final rest = await Future.wait(
          List.generate(
            lastPage - 1,
            (i) => _client.dio.get(
              '/api/v1/farmers',
              queryParameters: {...params, 'page': i + 2},
            ),
          ),
        );
        for (final r in rest) {
          farmers.addAll(
            _parsePage((r.data as Map<String, dynamic>)['data'] as List),
          );
        }
      }

      return farmers;
    } on DioException catch (e) {
      throw _toAppException(e, 'Failed to load farmers.');
    }
  }

  List<Farmer> _parsePage(List raw) =>
      raw.map((j) => Farmer.fromJson(j as Map<String, dynamic>)).toList();

  Future<Farmer> getFarmer(int id) async {
    try {
      final response = await _client.dio.get('/api/v1/farmers/$id');
      final data =
          (response.data as Map<String, dynamic>)['data']
              as Map<String, dynamic>;
      return Farmer.fromJson(data);
    } on DioException catch (e) {
      throw _toAppException(e, 'Failed to load farmer.');
    }
  }

  Future<List<Debt>> getFarmerDebts(int farmerId) async {
    try {
      final response = await _client.dio.get('/api/v1/farmers/$farmerId/debts');
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return data.map((j) => Debt.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _toAppException(e, 'Failed to load debts.');
    }
  }

  Future<Farmer> createFarmer({
    required String identifier,
    required String firstname,
    required String lastname,
    required String phone,
    required double creditLimit,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/v1/farmers',
        data: {
          'identifier': identifier,
          'firstname': firstname,
          'lastname': lastname,
          'phone': phone,
          'credit_limit': creditLimit,
        },
      );
      final data =
          (response.data as Map<String, dynamic>)['data']
              as Map<String, dynamic>;
      return Farmer.fromJson(data);
    } on DioException catch (e) {
      throw _toAppException(e, 'Failed to create farmer.');
    }
  }

  AppException _toAppException(DioException e, String fallback) {
    if (e.response != null) {
      final body = e.response!.data;
      final message = (body is Map && body['message'] is String)
          ? body['message'] as String
          : fallback;
      final errors = (body is Map && body['errors'] is Map)
          ? Map<String, dynamic>.from(body['errors'] as Map)
          : null;
      return AppException(
        message: message,
        statusCode: e.response!.statusCode,
        errors: errors,
      );
    }
    return const AppException(message: 'Connection error. Check your network.');
  }
}

@riverpod
FarmerRepository farmerRepository(Ref ref) {
  return FarmerRepository(ref.watch(dioClientProvider));
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/errors/app_exception.dart';
import '../../../features/auth/providers/auth_provider.dart';
import 'farmer.dart';

part 'farmer_repository.g.dart';

class FarmerRepository {
  final DioClient _client;

  const FarmerRepository(this._client);

  Future<List<Farmer>> getFarmers({String? search}) async {
    try {
      final response = await _client.dio.get(
        '/api/v1/farmers',
        queryParameters: search != null && search.isNotEmpty
            ? {'search': search}
            : null,
      );
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return data
          .map((j) => Farmer.fromJson(j as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final body = e.response!.data;
        final message = (body is Map && body['message'] is String)
            ? body['message'] as String
            : 'Failed to load farmers.';
        throw AppException(
          message: message,
          statusCode: e.response!.statusCode,
        );
      }
      throw const AppException(
        message: 'Connection error. Check your network.',
      );
    }
  }
}

@riverpod
FarmerRepository farmerRepository(Ref ref) {
  return FarmerRepository(ref.watch(dioClientProvider));
}

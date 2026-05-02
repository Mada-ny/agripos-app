import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/errors/app_exception.dart';
import '../../../features/auth/providers/auth_provider.dart';

part 'repayment_repository.g.dart';

class RepaymentRepository {
  final DioClient _client;

  const RepaymentRepository(this._client);

  Future<void> createRepayment({
    required int farmerId,
    required double kgReceived,
    required double commodityRate,
  }) async {
    try {
      await _client.dio.post(
        '/api/v1/repayments',
        data: {
          'farmer_id': farmerId,
          'kg_received': kgReceived,
          'commodity_rate': commodityRate,
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final body = e.response!.data;
        final message = (body is Map && body['message'] is String)
            ? body['message'] as String
            : 'Failed to record repayment.';
        final errors = (body is Map && body['errors'] is Map)
            ? Map<String, dynamic>.from(body['errors'] as Map)
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
    }
  }
}

@riverpod
RepaymentRepository repaymentRepository(Ref ref) {
  return RepaymentRepository(ref.watch(dioClientProvider));
}

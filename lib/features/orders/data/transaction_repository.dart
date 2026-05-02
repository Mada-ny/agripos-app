import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/errors/app_exception.dart';
import '../../auth/providers/auth_provider.dart';
import 'transaction.dart';

part 'transaction_repository.g.dart';

class TransactionRepository {
  const TransactionRepository(this._client);
  final DioClient _client;

  Future<Transaction> createTransaction({
    required int farmerId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    int? interestRate,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/v1/transactions',
        data: {
          'farmer_id': farmerId,
          'payment_method': paymentMethod,
          'items': items,
          'interest_rate': interestRate,
        }..removeWhere((_, v) => v == null),
      );
      return Transaction.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        final message = (data is Map && data['message'] is String)
            ? data['message'] as String
            : 'Failed to create order. Please try again.';
        final errors = (data is Map && data['errors'] is Map)
            ? Map<String, dynamic>.from(data['errors'] as Map)
            : null;
        throw AppException(
          message: message,
          statusCode: e.response!.statusCode,
          errors: errors,
        );
      }
      throw const AppException(message: 'Connection error. Please try again.');
    }
  }
}

@riverpod
TransactionRepository transactionRepository(Ref ref) =>
    TransactionRepository(ref.watch(dioClientProvider));

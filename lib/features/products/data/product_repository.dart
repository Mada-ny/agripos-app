import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/errors/app_exception.dart';
import '../../../features/auth/providers/auth_provider.dart';
import 'category.dart';
import 'product.dart';

part 'product_repository.g.dart';

class ProductRepository {
  final DioClient _client;

  const ProductRepository(this._client);

  Future<List<Product>> getProducts() async {
    try {
      final first = await _client.dio.get('/api/v1/products');
      final body = first.data as Map<String, dynamic>;
      final products = _parsePage(body['data'] as List);

      final lastPage =
          ((body['meta'] as Map<String, dynamic>?)?['last_page'] as int?) ?? 1;

      if (lastPage > 1) {
        final rest = await Future.wait(
          List.generate(
            lastPage - 1,
            (i) => _client.dio.get(
              '/api/v1/products',
              queryParameters: {'page': i + 2},
            ),
          ),
        );
        for (final r in rest) {
          products.addAll(
            _parsePage((r.data as Map<String, dynamic>)['data'] as List),
          );
        }
      }

      return products;
    } on DioException catch (e) {
      throw _toAppException(e, 'Failed to load products.');
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await _client.dio.get('/api/v1/categories');
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return data
          .map((j) => Category.fromJson(j as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _toAppException(e, 'Failed to load categories.');
    }
  }

  List<Product> _parsePage(List raw) =>
      raw.map((j) => Product.fromJson(j as Map<String, dynamic>)).toList();

  AppException _toAppException(DioException e, String fallback) {
    if (e.response != null) {
      final body = e.response!.data;
      final message = (body is Map && body['message'] is String)
          ? body['message'] as String
          : fallback;
      return AppException(message: message, statusCode: e.response!.statusCode);
    }
    return const AppException(message: 'Connection error. Check your network.');
  }
}

@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepository(ref.watch(dioClientProvider));
}

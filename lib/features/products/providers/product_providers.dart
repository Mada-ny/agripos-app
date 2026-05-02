import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/category.dart';
import '../data/product.dart';
import '../data/product_repository.dart';

part 'product_providers.g.dart';

@riverpod
Future<List<Product>> productList(Ref ref) async {
  return ref.read(productRepositoryProvider).getProducts();
}

@riverpod
Future<List<Category>> categoryList(Ref ref) async {
  return ref.read(productRepositoryProvider).getCategories();
}

// Tracks the selected category ID (null = all products).
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  int? build() => null;

  void select(int? id) => state = id;
}

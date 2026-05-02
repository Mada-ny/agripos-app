// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productListHash() => r'5cd687995815540460bc05eb42146ca17d810a31';

/// See also [productList].
@ProviderFor(productList)
final productListProvider = AutoDisposeFutureProvider<List<Product>>.internal(
  productList,
  name: r'productListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductListRef = AutoDisposeFutureProviderRef<List<Product>>;
String _$categoryListHash() => r'029d639aab4163693ebda7b232c9d6c661ad21f2';

/// See also [categoryList].
@ProviderFor(categoryList)
final categoryListProvider = AutoDisposeFutureProvider<List<Category>>.internal(
  categoryList,
  name: r'categoryListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryListRef = AutoDisposeFutureProviderRef<List<Category>>;
String _$selectedCategoryHash() => r'92d89391026dc2ea1445e6d2710e89816bab465a';

/// See also [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, int?>.internal(
      SelectedCategory.new,
      name: r'selectedCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCategory = AutoDisposeNotifier<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

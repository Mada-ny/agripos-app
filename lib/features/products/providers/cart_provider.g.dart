// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cartHash() => r'3e20ec5f0f0036ceb31c1c28125368edfa0b835f';

/// See also [Cart].
@ProviderFor(Cart)
final cartProvider = NotifierProvider<Cart, Map<int, CartItem>>.internal(
  Cart.new,
  name: r'cartProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Cart = Notifier<Map<int, CartItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

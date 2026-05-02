// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$farmerListHash() => r'd667017b726a7880014edd2237a725828721d3c0';

/// See also [farmerList].
@ProviderFor(farmerList)
final farmerListProvider = AutoDisposeFutureProvider<List<Farmer>>.internal(
  farmerList,
  name: r'farmerListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$farmerListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FarmerListRef = AutoDisposeFutureProviderRef<List<Farmer>>;
String _$farmerListVersionHash() => r'b00e3a56881233fb60a57f0fc598c2bbcfbe6428';

/// See also [FarmerListVersion].
@ProviderFor(FarmerListVersion)
final farmerListVersionProvider =
    NotifierProvider<FarmerListVersion, int>.internal(
      FarmerListVersion.new,
      name: r'farmerListVersionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$farmerListVersionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FarmerListVersion = Notifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

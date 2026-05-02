// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$farmerDetailHash() => r'86468cc0e82dd0c71869526bb385aef279a2fa78';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [farmerDetail].
@ProviderFor(farmerDetail)
const farmerDetailProvider = FarmerDetailFamily();

/// See also [farmerDetail].
class FarmerDetailFamily extends Family<AsyncValue<Farmer>> {
  /// See also [farmerDetail].
  const FarmerDetailFamily();

  /// See also [farmerDetail].
  FarmerDetailProvider call(int farmerId) {
    return FarmerDetailProvider(farmerId);
  }

  @override
  FarmerDetailProvider getProviderOverride(
    covariant FarmerDetailProvider provider,
  ) {
    return call(provider.farmerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'farmerDetailProvider';
}

/// See also [farmerDetail].
class FarmerDetailProvider extends AutoDisposeFutureProvider<Farmer> {
  /// See also [farmerDetail].
  FarmerDetailProvider(int farmerId)
    : this._internal(
        (ref) => farmerDetail(ref as FarmerDetailRef, farmerId),
        from: farmerDetailProvider,
        name: r'farmerDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$farmerDetailHash,
        dependencies: FarmerDetailFamily._dependencies,
        allTransitiveDependencies:
            FarmerDetailFamily._allTransitiveDependencies,
        farmerId: farmerId,
      );

  FarmerDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmerId,
  }) : super.internal();

  final int farmerId;

  @override
  Override overrideWith(
    FutureOr<Farmer> Function(FarmerDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FarmerDetailProvider._internal(
        (ref) => create(ref as FarmerDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmerId: farmerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Farmer> createElement() {
    return _FarmerDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmerDetailProvider && other.farmerId == farmerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FarmerDetailRef on AutoDisposeFutureProviderRef<Farmer> {
  /// The parameter `farmerId` of this provider.
  int get farmerId;
}

class _FarmerDetailProviderElement
    extends AutoDisposeFutureProviderElement<Farmer>
    with FarmerDetailRef {
  _FarmerDetailProviderElement(super.provider);

  @override
  int get farmerId => (origin as FarmerDetailProvider).farmerId;
}

String _$farmerDebtsHash() => r'a564f5c959a73b4917966750cea138429496a87b';

/// See also [farmerDebts].
@ProviderFor(farmerDebts)
const farmerDebtsProvider = FarmerDebtsFamily();

/// See also [farmerDebts].
class FarmerDebtsFamily extends Family<AsyncValue<List<Debt>>> {
  /// See also [farmerDebts].
  const FarmerDebtsFamily();

  /// See also [farmerDebts].
  FarmerDebtsProvider call(int farmerId) {
    return FarmerDebtsProvider(farmerId);
  }

  @override
  FarmerDebtsProvider getProviderOverride(
    covariant FarmerDebtsProvider provider,
  ) {
    return call(provider.farmerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'farmerDebtsProvider';
}

/// See also [farmerDebts].
class FarmerDebtsProvider extends AutoDisposeFutureProvider<List<Debt>> {
  /// See also [farmerDebts].
  FarmerDebtsProvider(int farmerId)
    : this._internal(
        (ref) => farmerDebts(ref as FarmerDebtsRef, farmerId),
        from: farmerDebtsProvider,
        name: r'farmerDebtsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$farmerDebtsHash,
        dependencies: FarmerDebtsFamily._dependencies,
        allTransitiveDependencies: FarmerDebtsFamily._allTransitiveDependencies,
        farmerId: farmerId,
      );

  FarmerDebtsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmerId,
  }) : super.internal();

  final int farmerId;

  @override
  Override overrideWith(
    FutureOr<List<Debt>> Function(FarmerDebtsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FarmerDebtsProvider._internal(
        (ref) => create(ref as FarmerDebtsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmerId: farmerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Debt>> createElement() {
    return _FarmerDebtsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmerDebtsProvider && other.farmerId == farmerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FarmerDebtsRef on AutoDisposeFutureProviderRef<List<Debt>> {
  /// The parameter `farmerId` of this provider.
  int get farmerId;
}

class _FarmerDebtsProviderElement
    extends AutoDisposeFutureProviderElement<List<Debt>>
    with FarmerDebtsRef {
  _FarmerDebtsProviderElement(super.provider);

  @override
  int get farmerId => (origin as FarmerDebtsProvider).farmerId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

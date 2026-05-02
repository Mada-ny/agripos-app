import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/farmer.dart';
import '../data/farmer_repository.dart';

part 'farmers_provider.g.dart';

// Incrementing this causes farmerListProvider to re-fetch immediately,
// regardless of whether FarmerSearchScreen is active or in the background.
@Riverpod(keepAlive: true)
class FarmerListVersion extends _$FarmerListVersion {
  @override
  int build() => 0;

  void refresh() => state++;
}

@riverpod
Future<List<Farmer>> farmerList(Ref ref) async {
  ref.watch(farmerListVersionProvider); // re-fetch whenever version bumps
  return ref.read(farmerRepositoryProvider).getFarmers();
}

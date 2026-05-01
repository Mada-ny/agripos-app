import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/farmer.dart';
import '../data/farmer_repository.dart';

part 'farmers_provider.g.dart';

@riverpod
Future<List<Farmer>> farmerList(Ref ref) async {
  return ref.read(farmerRepositoryProvider).getFarmers();
}

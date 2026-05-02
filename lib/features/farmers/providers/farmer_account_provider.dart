import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/debt.dart';
import '../data/farmer.dart';
import '../data/farmer_repository.dart';

part 'farmer_account_provider.g.dart';

@riverpod
Future<Farmer> farmerDetail(Ref ref, int farmerId) async {
  return ref.read(farmerRepositoryProvider).getFarmer(farmerId);
}

@riverpod
Future<List<Debt>> farmerDebts(Ref ref, int farmerId) async {
  return ref.read(farmerRepositoryProvider).getFarmerDebts(farmerId);
}

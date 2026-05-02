import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_exception.dart';
import '../data/farmer.dart';
import '../data/farmer_repository.dart';

part 'create_farmer_provider.g.dart';

@riverpod
class CreateFarmerNotifier extends _$CreateFarmerNotifier {
  @override
  AsyncValue<Farmer?> build() => const AsyncValue.data(null);

  Future<void> submit({
    required String identifier,
    required String firstname,
    required String lastname,
    required String phone,
    required double creditLimit,
  }) async {
    state = const AsyncValue.loading();
    try {
      final farmer = await ref
          .read(farmerRepositoryProvider)
          .createFarmer(
            identifier: identifier,
            firstname: firstname,
            lastname: lastname,
            phone: phone,
            creditLimit: creditLimit,
          );
      state = AsyncValue.data(farmer);
    } on AppException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(
        AppException(message: e.toString()),
        StackTrace.current,
      );
    }
  }
}

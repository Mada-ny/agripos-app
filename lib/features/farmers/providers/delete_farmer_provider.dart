import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_exception.dart';
import '../data/farmer_repository.dart';

part 'delete_farmer_provider.g.dart';

@riverpod
class DeleteFarmerNotifier extends _$DeleteFarmerNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> delete(int farmerId) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    try {
      await ref.read(farmerRepositoryProvider).deleteFarmer(farmerId);
      state = const AsyncValue.data(null);
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

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_exception.dart';
import '../data/repayment_repository.dart';

part 'repayment_provider.g.dart';

@riverpod
class RecordRepaymentNotifier extends _$RecordRepaymentNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> submit({
    required int farmerId,
    required double kgReceived,
    required double commodityRate,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(repaymentRepositoryProvider)
          .createRepayment(
            farmerId: farmerId,
            kgReceived: kgReceived,
            commodityRate: commodityRate,
          );
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

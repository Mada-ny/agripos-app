import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_exception.dart';
import '../data/transaction.dart';
import '../data/transaction_repository.dart';

part 'checkout_provider.g.dart';

@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  @override
  AsyncValue<Transaction?> build() => const AsyncValue.data(null);

  Future<void> submit({
    required int farmerId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    int? interestRate,
  }) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    try {
      final transaction = await ref
          .read(transactionRepositoryProvider)
          .createTransaction(
            farmerId: farmerId,
            paymentMethod: paymentMethod,
            items: items,
            interestRate: interestRate,
          );
      state = AsyncValue.data(transaction);
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

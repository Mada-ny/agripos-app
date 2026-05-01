import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_exception.dart';
import '../data/auth_repository.dart';
import 'auth_provider.dart';

part 'login_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> submit(String email, String password) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    try {
      final (user, token) = await ref
          .read(authRepositoryProvider)
          .login(email, password);
      await ref.read(authNotifierProvider.notifier).login(user, token);
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

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/storage/token_storage.dart';
import '../../../shared/models/user.dart';

part 'auth_provider.g.dart';

// Lives here because it needs to wire DioClient's onUnauthorized callback
// directly to the auth state reset — the only place both are in scope.
@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
  return DioClient(
    tokenStorage: ref.watch(tokenStorageProvider),
    onUnauthorized: () => ref.read(authNotifierProvider.notifier).logout(),
  );
}

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  static const _userCacheKey = 'cached_user';

  @override
  Future<User?> build() async {
    final token = await ref.read(tokenStorageProvider).readToken();
    if (token == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userCacheKey);
    if (raw == null) return null;

    try {
      return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> login(User user, String token) async {
    await ref.read(tokenStorageProvider).writeToken(token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userCacheKey, jsonEncode(user.toJson()));
    state = AsyncValue.data(user);
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider).deleteToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userCacheKey);
    state = const AsyncValue.data(null);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage.g.dart';

class TokenStorage {
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage;

  const TokenStorage(this._storage);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> deleteToken() => _storage.delete(key: _tokenKey);
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  return const TokenStorage(FlutterSecureStorage());
}

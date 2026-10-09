// author: juraj.suchan@gmail.com

import '../../core/auth/auth_store.dart';
import 'auth_repository.dart';
import 'token_request_result.dart';

class AuthService {
  AuthService(this._store, this._repo);

  final AuthStore _store;
  final AuthRepository _repo;

  bool get isAuthorized => _store.isAuthorized;
  String? get nick => _store.nick;

  Future<TokenRequestResult?> requestCode(String nick) async {
    final trimmed = nick.trim();
    if (trimmed.isEmpty) return null;

    final result = await _repo.requestToken(trimmed);
    if (result.isNew) {
      await _store.savePending(trimmed, result.token);
    }
    return result;
  }

  Future<bool> confirm() async {
    final token = _store.token;
    if (token == null || token.isEmpty) return false;
    await _store.confirm();
    return true;
  }

  Future<void> logout() async {
    final token = _store.token;
    if (_store.isAuthorized && token != null && token.isNotEmpty) {
      try {
        await _repo.unregisterPush(token);
      } catch (_) {}
    }
    await _store.clear();
  }
}

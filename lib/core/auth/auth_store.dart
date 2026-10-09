// author: juraj.suchan@gmail.com

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStore {
  AuthStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _kNick = 'AuthNick';
  static const _kToken = 'AuthToken';
  static const _kConfirmed = 'AuthConfirmed';

  final FlutterSecureStorage _storage;

  String? nick;
  String? token;
  bool confirmed = false;

  bool get isAuthorized => confirmed && token != null && token!.isNotEmpty;

  Future<void> load() async {
    nick = await _storage.read(key: _kNick);
    token = await _storage.read(key: _kToken);
    confirmed = (await _storage.read(key: _kConfirmed)) == 'true';
  }

  Future<void> savePending(String nick, String token) async {
    this.nick = nick;
    this.token = token;
    confirmed = false;
    await _storage.write(key: _kNick, value: nick);
    await _storage.write(key: _kToken, value: token);
    await _storage.write(key: _kConfirmed, value: 'false');
  }

  Future<void> confirm() async {
    confirmed = true;
    await _storage.write(key: _kConfirmed, value: 'true');
  }

  Future<void> clear() async {
    nick = null;
    token = null;
    confirmed = false;
    await _storage.delete(key: _kNick);
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kConfirmed);
  }
}

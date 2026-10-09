// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

class AuthorizedNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(authStoreProvider).isAuthorized;

  void set(bool value) => state = value;
}

final authorizedProvider = NotifierProvider<AuthorizedNotifier, bool>(
  AuthorizedNotifier.new,
);

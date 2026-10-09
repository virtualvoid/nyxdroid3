// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'latest_request_guard.dart';

mixin GuardedLoader<S> on Notifier<S>, LatestRequestGuard {
  Future<R?> guarded<R>({
    required S Function(S state) start,
    required Future<R> Function() fetch,
    required S Function(S state, R data) onData,
    required S Function(S state, Object error) onError,
  }) async {
    final id = beginRequest();
    state = start(state);
    try {
      final data = await fetch();
      if (isStale(id)) return null;
      state = onData(state, data);
      return data;
    } catch (e) {
      if (isStale(id)) return null;
      state = onError(state, e);
      return null;
    }
  }

  Future<R?> attempt<R>(
    Future<R> Function() body,
    S Function(S state, Object error) onError,
  ) async {
    try {
      return await body();
    } catch (e) {
      state = onError(state, e);
      return null;
    }
  }
}

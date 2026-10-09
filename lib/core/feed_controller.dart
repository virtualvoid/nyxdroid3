// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feed_state.dart';
import 'guarded_loader.dart';
import 'latest_request_guard.dart';
import 'models/api_context.dart';

abstract class FeedController<T> extends Notifier<FeedState<T>>
    with LatestRequestGuard, GuardedLoader<FeedState<T>> {
  Future<FeedPage<T>> fetch();

  @override
  FeedState<T> build() => FeedState<T>();

  Future<void> refresh() => guarded<FeedPage<T>>(
    start: (s) => s.copyWith(loading: true, clearError: true),
    fetch: fetch,
    onData: (s, page) =>
        FeedState<T>(items: page.$1, context: page.$2 ?? s.context),
    onError: (s, e) => s.copyWith(loading: false, error: e),
  );
}

typedef FeedPage<T> = (List<T> items, ApiContext? context);

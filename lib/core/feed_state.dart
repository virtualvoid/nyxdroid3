// author: juraj.suchan@gmail.com

import 'models/api_context.dart';

class FeedState<T> {
  const FeedState({
    this.items = const [],
    this.context,
    this.loading = false,
    this.error,
  });

  final List<T> items;
  final ApiContext? context;
  final bool loading;
  final Object? error;

  FeedState<T> copyWith({
    List<T>? items,
    ApiContext? context,
    bool? loading,
    Object? error,
    bool clearError = false,
  }) => FeedState<T>(
    items: items ?? this.items,
    context: context ?? this.context,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
  );
}

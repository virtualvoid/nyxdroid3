// author: juraj.suchan@gmail.com

import '../../core/models/last_post.dart';

class SearchState {
  const SearchState({
    this.user,
    this.text,
    this.items = const [],
    this.loading = false,
    this.loadingMore = false,
    this.reachedEnd = false,
    this.searched = false,
    this.error,
  });

  final String? user;
  final String? text;
  final List<LastPost> items;
  final bool loading;
  final bool loadingMore;
  final bool reachedEnd;
  final bool searched;
  final Object? error;

  SearchState copyWith({
    List<LastPost>? items,
    bool? loading,
    bool? loadingMore,
    bool? reachedEnd,
    Object? error,
    bool clearError = false,
  }) => SearchState(
    user: user,
    text: text,
    items: items ?? this.items,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    reachedEnd: reachedEnd ?? this.reachedEnd,
    searched: searched,
    error: clearError ? null : (error ?? this.error),
  );
}

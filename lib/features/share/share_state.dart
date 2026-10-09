// author: juraj.suchan@gmail.com

import '../bookmarks/bookmark_list_item.dart';

class ShareState {
  const ShareState({
    this.items = const [],
    this.loading = false,
    this.sending = false,
    this.error,
  });

  final List<BookmarkListItem> items;
  final bool loading;
  final bool sending;
  final Object? error;

  ShareState copyWith({
    List<BookmarkListItem>? items,
    bool? loading,
    bool? sending,
    Object? error,
    bool clearError = false,
  }) => ShareState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    sending: sending ?? this.sending,
    error: clearError ? null : (error ?? this.error),
  );
}

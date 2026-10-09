// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/api_context.dart';
import 'bookmark_list_item.dart';
import 'bookmarks_controller.dart';

class BookmarksState {
  const BookmarksState({
    this.all = const [],
    this.context,
    this.loading = false,
    this.error,
    required this.showRead,
    this.expansion = const {},
    this.searching = false,
    this.hasMore = false,
    this.moreResults = false,
  });

  final List<BookmarkListItem> all;
  final ApiContext? context;
  final bool loading;
  final Object? error;

  final bool showRead;

  final bool hasMore;
  final bool moreResults;

  final Map<int, bool> expansion;

  final bool searching;

  Set<int> get categoriesWithDiscussions => {
    for (final item in all)
      if (item is DiscussionItem && item.bookmark.categoryId != null)
        item.bookmark.categoryId!,
  };

  List<BookmarkListItem> get visible {
    if (searching) return all;

    final result = <BookmarkListItem>[];
    for (final item in all) {
      if (item is DiscussionItem && item.bookmark.categoryId != null) {
        final state = expansion[item.bookmark.categoryId];
        final show = switch (state) {
          true => true,
          false => false,
          null => showRead || item.bookmark.unread > 0,
        };
        if (!show) continue;
      }
      result.add(item);
    }
    return result;
  }

  BookmarksState copyWith({
    List<BookmarkListItem>? all,
    ApiContext? context,
    bool? loading,
    Object? error,
    bool clearError = false,
    bool? showRead,
    Map<int, bool>? expansion,
    bool? searching,
  }) => BookmarksState(
    all: all ?? this.all,
    context: context ?? this.context,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
    showRead: showRead ?? this.showRead,
    expansion: expansion ?? this.expansion,
    searching: searching ?? this.searching,
    hasMore: hasMore,
    moreResults: moreResults,
  );
}

final bookmarksControllerProvider =
    NotifierProvider.family<BookmarksController, BookmarksState, BookmarksMode>(
      BookmarksController.new,
    );

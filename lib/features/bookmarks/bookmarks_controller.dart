// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/guarded_loader.dart';
import '../../core/latest_request_guard.dart';
import '../../core/providers.dart';
import 'bookmark_list_item.dart';
import 'bookmarks_result.dart';
import 'bookmarks_state.dart';

class BookmarksController extends Notifier<BookmarksState>
    with LatestRequestGuard, GuardedLoader<BookmarksState> {
  BookmarksController(this.mode);

  final BookmarksMode mode;

  @override
  BookmarksState build() {
    final prefs = ref.read(appPrefsProvider);
    return BookmarksState(
      showRead: mode == BookmarksMode.history
          ? prefs.showReadHistory
          : prefs.showReadBookmarks,
    );
  }

  Future<void> refresh({required String remindersTitle}) async {
    await _load(
      searching: false,
      expansion: const {},
      fetch: () {
        final repo = ref.read(bookmarksRepositoryProvider);
        if (mode == BookmarksMode.history) {
          return repo.getHistory(
            includeRead: state.showRead,
            moreResults: state.moreResults,
            showBooked: ref.read(appPrefsProvider).historyShowBooked,
          );
        }
        return repo.getAll(
          includeRead: true,
          remindersEnabled: ref.read(appPrefsProvider).displayReminders,
          remindersTitle: remindersTitle,
        );
      },
    );
  }

  Future<void> loadMoreHistory() async {
    if (mode != BookmarksMode.history || !state.hasMore || state.loading) {
      return;
    }
    await _load(
      searching: false,
      expansion: const {},
      moreResults: true,
      fetch: () => ref
          .read(bookmarksRepositoryProvider)
          .getHistory(
            includeRead: state.showRead,
            moreResults: true,
            showBooked: ref.read(appPrefsProvider).historyShowBooked,
          ),
    );
  }

  Future<void> search(String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;
    await _load(
      searching: true,
      expansion: const {},
      fetch: () => ref.read(bookmarksRepositoryProvider).search(trimmed),
    );
  }

  Future<void> toggleShowRead({required String remindersTitle}) {
    state = state.copyWith(showRead: !state.showRead);
    return refresh(remindersTitle: remindersTitle);
  }

  void toggleCategory(int categoryId) {
    if (!state.categoriesWithDiscussions.contains(categoryId)) return;
    final current = state.expansion[categoryId];
    final next = current == null ? !state.showRead : !current;
    state = state.copyWith(expansion: {...state.expansion, categoryId: next});
  }

  void markRead(int discussionId) {
    state = state.copyWith(
      all: [
        for (final item in state.all)
          if (item is DiscussionItem && item.bookmark.id == discussionId)
            DiscussionItem(item.bookmark.markRead())
          else
            item,
      ],
    );
  }

  Future<bool> markHistoryRead(List<int> discussionIds) async {
    if (discussionIds.isEmpty) return true;
    final before = state.all;
    state = state.copyWith(
      all: [
        for (final item in before)
          if (item is DiscussionItem &&
              discussionIds.contains(item.bookmark.id))
            DiscussionItem(item.bookmark.markRead())
          else
            item,
      ],
    );
    final ok = await attempt<bool>(() async {
      await ref
          .read(bookmarksRepositoryProvider)
          .markHistoryRead(discussionIds);
      return true;
    }, (s, e) => s.copyWith(all: before, error: e));
    return ok == true;
  }

  Future<bool> markAllHistoryRead() => markHistoryRead([
    for (final item in state.all)
      if (item is DiscussionItem && item.bookmark.unread > 0) item.bookmark.id,
  ]);

  Future<bool> removeFromHistory(List<int> discussionIds) async {
    if (discussionIds.isEmpty) return true;
    final before = state.all;
    state = state.copyWith(
      all: [
        for (final item in before)
          if (item is! DiscussionItem ||
              !discussionIds.contains(item.bookmark.id))
            item,
      ],
    );
    final ok = await attempt<bool>(() async {
      await ref
          .read(bookmarksRepositoryProvider)
          .removeFromHistory(discussionIds);
      return true;
    }, (s, e) => s.copyWith(all: before, error: e));
    return ok == true;
  }

  Future<void> _load({
    required bool searching,
    required Map<int, bool> expansion,
    required Future<BookmarksResult> Function() fetch,
    bool? moreResults,
  }) => guarded<BookmarksResult>(
    start: (s) => s.copyWith(loading: true, clearError: true),
    fetch: fetch,
    onData: (s, r) => BookmarksState(
      all: r.items,
      context: r.context ?? s.context,
      showRead: s.showRead,
      expansion: expansion,
      searching: searching,
      hasMore: r.hasMore,
      moreResults: moreResults ?? (searching ? false : s.moreResults),
    ),
    onError: (s, e) => s.copyWith(loading: false, error: e),
  );
}

enum BookmarksMode { bookmarks, history }

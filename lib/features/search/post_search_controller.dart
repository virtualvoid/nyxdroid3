// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/guarded_loader.dart';
import '../../core/latest_request_guard.dart';
import '../../core/providers.dart';
import '../../core/search_text.dart';
import 'search_page.dart';
import 'search_state.dart';

class PostSearchController extends Notifier<SearchState>
    with LatestRequestGuard, GuardedLoader<SearchState> {
  @override
  SearchState build() => const SearchState();

  Future<void> search(String raw) async {
    final parts = splitSearch(raw.trim());
    if (parts == null) return;
    if ((parts.user == null || parts.user!.isEmpty) &&
        (parts.text == null || parts.text!.isEmpty)) {
      return;
    }

    final user = parts.user;
    final text = parts.text;
    final id = beginRequest();
    state = SearchState(user: user, text: text, loading: true, searched: true);
    try {
      final SearchPage page = await ref
          .read(searchRepositoryProvider)
          .posts(user: user, text: text);
      if (isStale(id)) return;
      state = SearchState(
        user: user,
        text: text,
        items: page.posts,
        reachedEnd: page.posts.isEmpty,
        searched: true,
      );
    } catch (e) {
      if (isStale(id)) return;
      state = SearchState(user: user, text: text, searched: true, error: e);
    }
  }

  Future<void> loadMore() async {
    if (!state.searched ||
        state.loading ||
        state.loadingMore ||
        state.reachedEnd ||
        state.items.isEmpty) {
      return;
    }

    final lastId = state.items.last.writeup.id;
    state = state.copyWith(loadingMore: true, clearError: true);
    final id = beginRequest();
    try {
      final page = await ref
          .read(searchRepositoryProvider)
          .posts(user: state.user, text: state.text, olderThanId: lastId);
      if (isStale(id)) return;
      final known = {for (final p in state.items) p.writeup.id};
      final fresh = [
        for (final p in page.posts)
          if (!known.contains(p.writeup.id)) p,
      ];
      state = state.copyWith(
        items: [...state.items, ...fresh],
        loadingMore: false,
        reachedEnd: fresh.isEmpty,
      );
    } catch (e) {
      if (isStale(id)) return;
      state = state.copyWith(loadingMore: false, error: e);
    }
  }
}

final postSearchControllerProvider =
    NotifierProvider.autoDispose<PostSearchController, SearchState>(
      PostSearchController.new,
    );

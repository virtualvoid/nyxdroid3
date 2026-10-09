// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/guarded_loader.dart';
import '../../core/latest_request_guard.dart';
import '../../core/models/discussion_page.dart';
import '../../core/models/writeup.dart';
import '../../core/providers.dart';
import '../../core/search_text.dart';
import 'discussion_repository.dart';
import 'discussion_state.dart';
import 'scroll_request.dart';

class DiscussionController extends Notifier<DiscussionState>
    with LatestRequestGuard, GuardedLoader<DiscussionState> {
  DiscussionController(this.args);

  final DiscussionArgs args;

  int _scrollNonce = 0;

  DiscussionRepository get _repo => ref.read(discussionRepositoryProvider);

  @override
  DiscussionState build() => DiscussionState(id: args.id);

  ScrollRequest _scrollTo(int index) => ScrollRequest(index, ++_scrollNonce);

  Future<void> loadInitial() => _loadFresh(startAt: args.wuId);

  Future<void> refresh() => _loadFresh();

  Future<void> search(String text) {
    final parts = splitSearch(text.trim());
    if (parts == null) return Future.value();
    return _loadFresh(filterUser: parts.user, filterText: parts.text);
  }

  Future<void> _loadFresh({
    int? startAt,
    String? filterUser,
    String? filterText,
  }) => guarded<DiscussionPage>(
    start: (s) =>
        s.copyWith(loading: true, loadingMore: false, clearError: true),
    fetch: () => _repo.getWriteups(
      args.id,
      direction: startAt == null
          ? WriteupDirection.newest
          : WriteupDirection.older,
      lastId: startAt,
      filterUser: filterUser,
      filterText: filterText,
    ),
    onData: (s, page) {
      final next = s.copyWith(
        clearFilter: filterUser == null && filterText == null,
        filterUser: filterUser,
        filterText: filterText,
        name: page.name,
        writeups: page.writeups,
        booked: page.booked,
        canWrite: page.canWrite,
        canDelete: page.canDelete,
        loading: false,
        reachedEnd: false,
        context: page.context,
      );
      return next.copyWith(scroll: _scrollTo(next.lastUnreadIndex));
    },
    onError: _failLoading,
  );

  Future<void> loadMore() async {
    if (state.loading ||
        state.loadingMore ||
        state.reachedEnd ||
        state.writeups.isEmpty) {
      return;
    }
    await guarded<DiscussionPage>(
      start: (s) => s.copyWith(loadingMore: true, clearError: true),
      fetch: () => _repo.getWriteups(
        args.id,
        direction: WriteupDirection.older,
        lastId: state.writeups.last.id,
        filterUser: state.filterUser,
        filterText: state.filterText,
      ),
      onData: (s, page) {
        final fresh = _unseen(s, page.writeups);
        return s.copyWith(
          writeups: [...s.writeups, ...fresh],
          loadingMore: false,
          reachedEnd: fresh.isEmpty,
          context: page.context,
        );
      },
      onError: (s, e) => s.copyWith(loadingMore: false, error: e),
    );
  }

  Future<bool> jumpTo(int writeupId) async {
    if (state.indexOf(writeupId) == -1) {
      final page = await guarded<DiscussionPage>(
        start: (s) => s.copyWith(loading: true, clearError: true),
        fetch: () => _repo.getWriteups(
          args.id,
          direction: WriteupDirection.older,
          lastId: writeupId,
        ),
        onData: (s, page) => s.copyWith(
          writeups: [...s.writeups, ..._unseen(s, page.writeups)],
          loading: false,
        ),
        onError: _failLoading,
      );
      if (page == null) return false;
    }

    final index = state.indexOf(writeupId);
    if (index == -1) return false;
    state = state.copyWith(scroll: _scrollTo(index));
    return true;
  }

  Future<VotingResult> vote(int writeupId, VotingType tapped) async {
    final index = state.indexOf(writeupId);
    if (index == -1) return VotingResult.error;

    final type = state.writeups[index].myRating.isEmpty
        ? tapped
        : VotingType.remove;
    return _sendVote(writeupId, type);
  }

  Future<VotingResult> confirmNegativeVisible(int writeupId) =>
      _sendVote(writeupId, VotingType.negativeVisible);

  Future<VotingResult> _sendVote(int writeupId, VotingType type) async {
    final r = await attempt(
      () => _repo.giveRating(args.id, writeupId, type),
      _setError,
    );
    if (r == null) return VotingResult.error;

    if (r.result == VotingResult.changed) {
      _replace(
        writeupId,
        (w) => w.copyWith(
          rating: r.currentRating ?? 0,
          myRating: type.isRemove ? '' : type.value,
        ),
      );
    }
    return r.result;
  }

  Future<void> pollVote(int writeupId, String answerKey) async {
    final updated = await attempt(
      () => _repo.pollVote(args.id, writeupId, answerKey),
      _setError,
    );
    if (updated != null) _replace(writeupId, (_) => updated);
  }

  Future<void> unbook() async {
    final booked = await attempt(
      () => _repo.setBookmark(args.id, book: false),
      _setError,
    );
    if (booked != null) state = state.copyWith(booked: booked);
  }

  Future<void> book(int categoryId) async {
    final booked = await attempt(
      () => _repo.setBookmark(args.id, book: true, categoryId: categoryId),
      _setError,
    );
    if (booked != null) state = state.copyWith(booked: booked);
  }

  Future<void> toggleReminder(int writeupId) async {
    final index = state.indexOf(writeupId);
    if (index == -1) return;
    final newState = !state.writeups[index].isReminded;

    final ok = await attempt(() async {
      await _repo.setReminder(args.id, writeupId, newState);
      return true;
    }, _setError);
    if (ok == true) {
      _replace(writeupId, (w) => w.copyWith(isReminded: newState));
    }
  }

  Future<void> deleteWriteup(int writeupId) async {
    final ok = await attempt(() async {
      await _repo.deleteWriteup(args.id, writeupId);
      return true;
    }, _setError);
    if (ok == true) {
      state = state.copyWith(
        writeups: [
          for (final w in state.writeups)
            if (w.id != writeupId) w,
        ],
      );
    }
  }

  Future<int> showReplies(int writeupId) async {
    final page = await guarded<DiscussionPage>(
      start: (s) => s.copyWith(loading: true, clearError: true),
      fetch: () => _repo.getWriteups(
        args.id,
        direction: WriteupDirection.newer,
        lastId: writeupId,
        filterText: '$writeupId',
      ),
      onData: (s, page) => page.writeups.isEmpty
          ? s.copyWith(loading: false)
          : s.copyWith(
              writeups: page.writeups,
              loading: false,
              reachedEnd: true,
              context: page.context,
              scroll: _scrollTo(0),
            ),
      onError: _failLoading,
    );
    return page?.writeups.length ?? 0;
  }

  List<Writeup> _unseen(DiscussionState s, List<Writeup> incoming) {
    final known = {for (final w in s.writeups) w.id};
    return incoming.where((w) => !known.contains(w.id)).toList();
  }

  DiscussionState _failLoading(DiscussionState s, Object e) =>
      s.copyWith(loading: false, error: e);

  DiscussionState _setError(DiscussionState s, Object e) =>
      s.copyWith(error: e);

  void _replace(int writeupId, Writeup Function(Writeup) change) {
    state = state.copyWith(
      writeups: [
        for (final w in state.writeups) w.id == writeupId ? change(w) : w,
      ],
    );
  }
}

typedef DiscussionArgs = ({int id, int? wuId});

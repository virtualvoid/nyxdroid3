// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/guarded_loader.dart';
import '../../core/latest_request_guard.dart';
import '../../core/models/discussion_page.dart';
import '../../core/models/writeup.dart';
import '../../core/providers.dart';
import '../discussion/discussion_repository.dart';
import 'gallery_grid_state.dart';
import 'gallery_image.dart';

class GalleryGridController extends Notifier<GalleryGridState>
    with LatestRequestGuard, GuardedLoader<GalleryGridState> {
  GalleryGridController(this.discussionId);

  final int discussionId;

  @override
  GalleryGridState build() => const GalleryGridState();

  Future<void> loadFirst() => _load(first: true);

  Future<void> loadMore() async {
    if (state.loading ||
        state.reachedEnd ||
        state.images.isEmpty && state.lastWriteupId == null) {
      return;
    }
    await _load(first: false);
  }

  Future<void> _load({required bool first}) => guarded<DiscussionPage>(
    start: (s) => s.copyWith(loading: true, clearError: true),
    fetch: () => ref
        .read(discussionRepositoryProvider)
        .getWriteups(
          discussionId,
          direction: first ? WriteupDirection.newest : WriteupDirection.older,
          lastId: first ? null : state.lastWriteupId,
          filterText: 'img src',
        ),
    onData: (s, page) {
      final known = first ? <int, Writeup>{} : s.writeups;
      final fresh = page.writeups
          .where((w) => !known.containsKey(w.id))
          .toList();
      return GalleryGridState(
        name: page.name,
        images: [
          if (!first) ...s.images,
          for (final w in fresh) ...imagesOf(w),
        ],
        writeups: {...known, for (final w in fresh) w.id: w},
        lastWriteupId: fresh.isEmpty
            ? (first ? null : s.lastWriteupId)
            : fresh.last.id,
        reachedEnd: !first && fresh.isEmpty,
      );
    },
    onError: (s, e) => s.copyWith(loading: false, error: e),
  );
}

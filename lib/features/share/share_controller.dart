// author: juraj.suchan@gmail.com

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/attachment_file.dart';
import '../../core/guarded_loader.dart';
import '../../core/latest_request_guard.dart';
import '../../core/providers.dart';
import '../bookmarks/bookmarks_result.dart';
import 'share_outcome.dart';
import 'share_state.dart';
import 'shared_content.dart';

class ShareController extends Notifier<ShareState>
    with LatestRequestGuard, GuardedLoader<ShareState> {
  @override
  ShareState build() => const ShareState();

  Future<void> load() => guarded<BookmarksResult>(
    start: (s) => s.copyWith(loading: true, clearError: true),
    fetch: () => ref
        .read(bookmarksRepositoryProvider)
        .getAll(includeRead: true, remindersEnabled: false, remindersTitle: ''),
    onData: (s, r) => ShareState(items: r.items),
    onError: (s, e) => s.copyWith(loading: false, error: e),
  );

  Future<ShareOutcome> send(
    int discussionId,
    String message,
    SharedContent content,
  ) async {
    if (state.sending) return ShareOutcome.failed;
    final path = content.imagePath;
    if (content.isImage && (path == null || !File(path).existsSync())) {
      return ShareOutcome.unreadable;
    }

    state = state.copyWith(sending: true, clearError: true);
    final done = await attempt<bool>(() async {
      final MultipartFile? attachment = content.isImage
          ? await attachmentFromPath(path!, name: content.name)
          : null;
      final text = content.isImage
          ? message
          : [message, content.text ?? ''].where((e) => e.isNotEmpty).join(' ');
      await ref
          .read(discussionRepositoryProvider)
          .sendWriteup(discussionId, text, attachment: attachment);
      return true;
    }, (s, e) => s.copyWith(sending: false, error: e));

    if (done != true) return ShareOutcome.failed;
    state = state.copyWith(sending: false);
    return ShareOutcome.sent;
  }
}

final shareControllerProvider =
    NotifierProvider.autoDispose<ShareController, ShareState>(
      ShareController.new,
    );

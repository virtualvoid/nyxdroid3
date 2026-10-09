// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/api_context.dart';
import '../../core/models/writeup.dart';
import 'discussion_controller.dart';
import 'scroll_request.dart';

class DiscussionState {
  const DiscussionState({
    required this.id,
    this.name = '',
    this.writeups = const [],
    this.booked = false,
    this.canWrite = false,
    this.canDelete = false,
    this.loading = false,
    this.loadingMore = false,
    this.reachedEnd = false,
    this.error,
    this.context,
    this.scroll,
    this.filterUser,
    this.filterText,
  });

  final int id;
  final String name;

  final List<Writeup> writeups;
  final bool booked;
  final bool canWrite;
  final bool canDelete;
  final bool loading;
  final bool loadingMore;
  final bool reachedEnd;
  final Object? error;
  final ApiContext? context;
  final ScrollRequest? scroll;
  final String? filterUser;
  final String? filterText;

  bool get filtered =>
      (filterUser ?? '').isNotEmpty || (filterText ?? '').isNotEmpty;

  int get lastUnreadIndex {
    for (var i = writeups.length - 1; i >= 0; i--) {
      if (writeups[i].unread) return i;
    }
    return 0;
  }

  int indexOf(int writeupId) => writeups.indexWhere((w) => w.id == writeupId);

  DiscussionState copyWith({
    String? name,
    List<Writeup>? writeups,
    bool? booked,
    bool? canWrite,
    bool? canDelete,
    bool? loading,
    bool? loadingMore,
    bool? reachedEnd,
    Object? error,
    bool clearError = false,
    ApiContext? context,
    ScrollRequest? scroll,
    String? filterUser,
    String? filterText,
    bool clearFilter = false,
  }) => DiscussionState(
    id: id,
    name: name ?? this.name,
    writeups: writeups ?? this.writeups,
    booked: booked ?? this.booked,
    canWrite: canWrite ?? this.canWrite,
    canDelete: canDelete ?? this.canDelete,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    reachedEnd: reachedEnd ?? this.reachedEnd,
    error: clearError ? null : (error ?? this.error),
    context: context ?? this.context,
    scroll: scroll ?? this.scroll,
    filterUser: clearFilter ? null : (filterUser ?? this.filterUser),
    filterText: clearFilter ? null : (filterText ?? this.filterText),
  );
}

final discussionControllerProvider =
    NotifierProvider.family<
      DiscussionController,
      DiscussionState,
      DiscussionArgs
    >(DiscussionController.new);

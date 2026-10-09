// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_content.dart';

class PendingShareNotifier extends Notifier<SharedContent?> {
  @override
  SharedContent? build() => null;

  void set(SharedContent content) => state = content;

  void clear() => state = null;
}

final pendingShareProvider =
    NotifierProvider<PendingShareNotifier, SharedContent?>(
      PendingShareNotifier.new,
    );

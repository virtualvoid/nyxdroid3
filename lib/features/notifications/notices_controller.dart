// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/feed_controller.dart';
import '../../core/feed_state.dart';
import '../../core/models/notice.dart';
import '../../core/providers.dart';
import 'status_counts_provider.dart';

class NoticesController extends FeedController<Notice> {
  @override
  Future<FeedPage<Notice>> fetch() async {
    final r = await ref
        .read(notificationsRepositoryProvider)
        .getNotifications();
    ref.invalidate(statusCountsProvider);
    return (r.notices, r.context);
  }
}

final noticesControllerProvider =
    NotifierProvider<NoticesController, FeedState<Notice>>(
      NoticesController.new,
    );

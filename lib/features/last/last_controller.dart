// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/feed_controller.dart';
import '../../core/feed_state.dart';
import '../../core/models/last_post.dart';
import '../../core/providers.dart';

class LastController extends FeedController<LastPost> {
  @override
  Future<FeedPage<LastPost>> fetch() async {
    final r = await ref.read(notificationsRepositoryProvider).getLast();
    return (r.posts, r.context);
  }
}

final lastControllerProvider =
    NotifierProvider<LastController, FeedState<LastPost>>(LastController.new);

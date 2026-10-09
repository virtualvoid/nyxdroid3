// author: juraj.suchan@gmail.com

import '../../core/api/api_client.dart';
import '../../core/json_utils.dart';
import '../../core/models/api_context.dart';
import '../../core/models/last_post.dart';
import '../../core/models/notice.dart';
import 'last_result.dart';
import 'notices_result.dart';

class NotificationsRepository {
  NotificationsRepository(this._api, {required this.nick});

  final ApiClient _api;
  final String? Function() nick;

  Future<NoticesResult> getNotifications() async {
    final root = asMap(await _api.get('/notifications')) ?? const {};
    final context = ApiContext.fromRoot(root);
    final lastVisit = context?.user.notificationsLastVisit;

    return NoticesResult([
      for (final n in asMapList(root['notifications']))
        ...Notice.fromNotification(n, lastVisit),
    ], context);
  }

  Future<LastResult> getLast() async {
    final root = asMap(await _api.get('/last')) ?? const {};
    final me = nick();
    return LastResult([
      for (final post in asMapList(root['posts']))
        ?LastPost.fromJson(post, myNick: me),
    ], ApiContext.fromRoot(root));
  }
}

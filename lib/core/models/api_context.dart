// author: juraj.suchan@gmail.com

import '../json_utils.dart';
import 'context_user.dart';
import 'user_activity.dart';

class ApiContext {
  const ApiContext({required this.user, this.activeFriends = const []});

  final ContextUser user;
  final List<UserActivity> activeFriends;

  static ApiContext? fromRoot(Map<String, dynamic> root) {
    final ctx = asMap(root['context']);
    final user = asMap(ctx?['user']);
    if (ctx == null || user == null) return null;
    return ApiContext(
      user: ContextUser.fromJson(user),
      activeFriends: asMapList(ctx['active_friends'])
          .map(UserActivity.fromJson)
          .toList(),
    );
  }
}

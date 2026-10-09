// author: juraj.suchan@gmail.com

import '../json_utils.dart';
import 'writeup.dart';

class LastPost {
  const LastPost({
    required this.writeup,
    required this.discussionId,
    required this.discussionName,
  });

  final Writeup writeup;
  final int discussionId;
  final String discussionName;

  static LastPost? fromJson(Map<String, dynamic> j, {String? myNick}) {
    final wu = Writeup.fromJson(j, myNick: myNick);
    final discussionId = asInt(j['discussion_id']);
    if (wu == null || discussionId == null) return null;
    return LastPost(
      writeup: wu,
      discussionId: discussionId,
      discussionName: asString(j['discussion_name']) ?? '',
    );
  }
}

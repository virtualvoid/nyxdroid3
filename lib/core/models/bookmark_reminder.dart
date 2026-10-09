// author: juraj.suchan@gmail.com

import '../json_utils.dart';

class BookmarkReminder {
  const BookmarkReminder({
    required this.id,
    required this.discussionId,
    required this.name,
    required this.nick,
    required this.replies,
    this.time,
  });

  final int id;
  final int discussionId;
  final String name;
  final String nick;
  final int replies;
  final DateTime? time;

  factory BookmarkReminder.fromJson(Map<String, dynamic> j) => BookmarkReminder(
    id: asInt(j['id']) ?? 0,
    discussionId: asInt(j['discussion_id']) ?? 0,
    name: asString(j['discussion_name']) ?? '',
    nick: asString(j['username']) ?? '',
    replies: j['replies'] is List ? (j['replies'] as List).length : 0,
    time: parseApiTime(j['inserted_at']),
  );
}

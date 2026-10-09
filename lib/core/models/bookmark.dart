// author: juraj.suchan@gmail.com

import '../json_utils.dart';

class Bookmark {
  const Bookmark({
    required this.id,
    required this.name,
    this.categoryId,
    this.unread = 0,
    this.replies = 0,
    this.lastSeenPostId = 0,
    this.lastVisitedAt,
  });

  final int id;
  final String name;
  final int? categoryId;
  final int unread;
  final int replies;

  final int lastSeenPostId;
  final DateTime? lastVisitedAt;

  factory Bookmark.fromJson(Map<String, dynamic> j, {int? categoryId}) =>
      Bookmark(
        id: asInt(j['discussion_id']) ?? 0,
        name: asString(j['full_name']) ?? '',
        categoryId: categoryId,
        unread: asInt(j['new_posts_count']) ?? 0,
        replies: asInt(j['new_replies_count']) ?? 0,
        lastSeenPostId: asInt(j['last_seen_post_id']) ?? 0,
        lastVisitedAt: parseApiTime(j['last_visited_at']),
      );

  Bookmark markRead() => Bookmark(
    id: id,
    name: name,
    categoryId: categoryId,
    lastSeenPostId: lastSeenPostId,
    lastVisitedAt: lastVisitedAt,
  );
}

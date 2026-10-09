// author: juraj.suchan@gmail.com

import '../json_utils.dart';

class Notice {
  const Notice({
    required this.type,
    this.discussionId,
    this.writeupId,
    this.nick = '',
    this.time,
    this.content = '',
    this.thumbs = 0,
    this.isNew = false,
  });

  final NoticeType type;
  final int? discussionId;
  final int? writeupId;
  final String nick;
  final DateTime? time;
  final String content;
  final int thumbs;
  final bool isNew;

  bool get opensDiscussion =>
      type != NoticeType.thumbs && discussionId != null && writeupId != null;

  static bool _isNewer(DateTime? time, DateTime? lastVisit) =>
      time != null && lastVisit != null && lastVisit.isBefore(time);

  static Notice? _post(
    NoticeType type,
    Map<String, dynamic> j,
    DateTime? lastVisit,
  ) {
    final nick = asString(j['username']);
    if (nick == null) return null;
    final time = parseApiTime(j['inserted_at']);
    return Notice(
      type: type,
      discussionId: asInt(j['discussion_id']),
      writeupId: asInt(j['id']),
      nick: nick,
      time: time,
      content: asString(j['content']) ?? '',
      isNew: _isNewer(time, lastVisit),
    );
  }

  static List<Notice> fromNotification(
    Map<String, dynamic> notification,
    DateTime? lastVisit,
  ) {
    final data = asMap(notification['data']);
    final main = data == null
        ? null
        : _post(NoticeType.notice, data, lastVisit);
    if (main == null) return const [];

    final details = asMap(notification['details']);
    final thumbs = details?['thumbs_up'];

    return [
      main,
      if (thumbs is List)
        Notice(
          type: NoticeType.thumbs,
          discussionId: main.discussionId,
          writeupId: main.writeupId,
          thumbs: thumbs.length,
        ),
      for (final reply in asMapList(details?['replies']))
        ?_post(NoticeType.reply, reply, lastVisit),
    ];
  }
}

enum NoticeType { notice, thumbs, reply }

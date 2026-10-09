// author: juraj.suchan@gmail.com

import '../json_utils.dart';
import 'user_activity.dart';

class Mail {
  const Mail({
    required this.id,
    required this.nick,
    required this.time,
    required this.content,
    this.incoming = false,
    this.unread = false,
    this.isReminded = false,
    this.isMine = false,
    this.location,
  });

  final int id;

  final String nick;
  final DateTime? time;

  final String content;
  final bool incoming;
  final bool unread;
  final bool isReminded;
  final bool isMine;
  final UserActivity? location;

  Mail copyWith({bool? isReminded}) => Mail(
    id: id,
    nick: nick,
    time: time,
    content: content,
    incoming: incoming,
    unread: unread,
    isReminded: isReminded ?? this.isReminded,
    isMine: isMine,
    location: location,
  );

  static Mail? fromJson(Map<String, dynamic> j, {String? myNick}) {
    final id = asInt(j['id']);
    final nick = asString(j['username']);
    if (id == null || nick == null) return null;

    final activity = asMap(j['activity']);
    return Mail(
      id: id,
      nick: nick,
      time: parseApiTime(j['inserted_at']),
      content: asString(j['content']) ?? '',
      incoming: asBool(j['incoming']),
      unread: asBool(j['unread']),
      isReminded: asBool(j['reminder']),
      isMine: myNick != null && myNick.toLowerCase() == nick.toLowerCase(),
      location: activity == null ? null : UserActivity.fromJson(activity),
    );
  }
}

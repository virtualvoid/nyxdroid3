// author: juraj.suchan@gmail.com

import '../json_utils.dart';

class Conversation {
  const Conversation({
    required this.nick,
    required this.time,
    required this.incoming,
  });

  final String nick;
  final DateTime? time;

  final bool incoming;

  static Conversation? fromJson(Map<String, dynamic> j) {
    final nick = asString(j['username']);
    if (nick == null) return null;
    return Conversation(
      nick: nick,
      time: parseApiTime(j['conversed_at']),
      incoming: asBool(j['incoming']),
    );
  }
}

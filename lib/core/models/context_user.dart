// author: juraj.suchan@gmail.com

import '../json_utils.dart';

class ContextUser {
  const ContextUser({
    required this.name,
    required this.unreadMail,
    required this.lastMailFrom,
    required this.unreadNotifications,
    required this.notificationsLastVisit,
  });

  final String name;
  final int unreadMail;
  final String? lastMailFrom;
  final int unreadNotifications;
  final DateTime? notificationsLastVisit;

  factory ContextUser.fromJson(Map<String, dynamic> j) => ContextUser(
    name: asString(j['username']) ?? '',
    unreadMail: asInt(j['mail_unread']) ?? 0,
    lastMailFrom: asString(j['mail_last_from']),
    unreadNotifications: asInt(j['notifications_unread']) ?? 0,
    notificationsLastVisit: parseApiTime(j['notifications_last_visit']),
  );
}

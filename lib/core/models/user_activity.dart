// author: juraj.suchan@gmail.com

import '../json_utils.dart';

class UserActivity {
  const UserActivity({
    this.username,
    this.lastActivity,
    this.location,
    this.locationUrl,
  });

  final String? username;
  final DateTime? lastActivity;
  final String? location;
  final String? locationUrl;

  bool get isValid => lastActivity != null;

  int? get discussionId {
    final url = locationUrl;
    if (url == null) return null;
    final m = RegExp(r'/discussion/(\d+)').firstMatch(url);
    return m == null ? null : int.tryParse(m.group(1)!);
  }

  factory UserActivity.fromJson(Map<String, dynamic> j) => UserActivity(
    username: asString(j['username']),
    lastActivity: parseApiTime(j['last_activity']),
    location: asString(j['location']),
    locationUrl: asString(j['location_url']),
  );
}

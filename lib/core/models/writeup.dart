// author: juraj.suchan@gmail.com

import '../json_utils.dart';
import 'poll_data.dart';
import 'user_activity.dart';

class Writeup {
  const Writeup({
    required this.id,
    required this.nick,
    required this.time,
    required this.content,
    this.unread = false,
    this.rating = 0,
    this.location,
    this.canDelete = false,
    this.isReminded = false,
    this.myRating = '',
    this.isMine = false,
    this.poll,
  });

  final int id;
  final String nick;
  final DateTime? time;

  final String content;
  final bool unread;
  final int rating;
  final UserActivity? location;
  final bool canDelete;
  final bool isReminded;

  final String myRating;
  final bool isMine;
  final PollData? poll;

  bool get isPoll => poll != null;

  Writeup copyWith({
    int? rating,
    String? myRating,
    bool? unread,
    bool? isReminded,
    PollData? poll,
  }) => Writeup(
    id: id,
    nick: nick,
    time: time,
    content: content,
    unread: unread ?? this.unread,
    rating: rating ?? this.rating,
    location: location,
    canDelete: canDelete,
    isReminded: isReminded ?? this.isReminded,
    myRating: myRating ?? this.myRating,
    isMine: isMine,
    poll: poll ?? this.poll,
  );

  static Writeup? fromJson(Map<String, dynamic> post, {String? myNick}) {
    final id = asInt(post['id']);
    final username = asString(post['username']);
    if (id == null || username == null) return null;

    PollData? poll;
    if (asString(post['post_type'])?.toLowerCase() == 'poll' &&
        post['content_raw'] != null) {
      final raw = asMap(post['content_raw']);
      final data = asMap(raw?['data']);
      if (asString(raw?['type'])?.toLowerCase() != 'poll' || data == null) {
        return null;
      }
      poll = PollData.fromJson(data);
      if (poll == null) return null;
    }

    final activity = asMap(post['activity']);
    return Writeup(
      id: id,
      nick: username,
      time: parseApiTime(post['inserted_at']),
      content: asString(post['content']) ?? '',
      unread: asBool(post['new']),
      rating: asInt(post['rating']) ?? 0,
      location: activity == null ? null : UserActivity.fromJson(activity),
      canDelete: asBool(post['can_be_deleted']),
      isReminded: asBool(post['reminder']),
      myRating: asString(post['my_rating']) ?? '',
      isMine: myNick != null && myNick.toLowerCase() == username.toLowerCase(),
      poll: poll,
    );
  }
}

enum VotingType {
  positive('positive'),
  negative('negative'),
  negativeVisible('negative_visible'),
  remove('remove');

  const VotingType(this.value);
  final String value;

  bool get isRemove => this == VotingType.remove;
}

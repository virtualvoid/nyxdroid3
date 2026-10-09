// author: juraj.suchan@gmail.com

import '../json_utils.dart';

class PollAnswer {
  const PollAnswer({
    required this.key,
    required this.answer,
    this.respondentsCount = 0,
    this.isMyVote = false,
  });

  final String key;
  final String answer;
  final int respondentsCount;
  final bool isMyVote;

  factory PollAnswer.fromJson(String key, Map<String, dynamic> j) {
    final meta = asMap(j['result']);
    return PollAnswer(
      key: key,
      answer: asString(j['answer']) ?? '',
      respondentsCount: asInt(meta?['respondents_count']) ?? 0,
      isMyVote: asBool(meta?['is_my_vote']),
    );
  }
}

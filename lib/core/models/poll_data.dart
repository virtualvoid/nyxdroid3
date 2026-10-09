// author: juraj.suchan@gmail.com

import '../json_utils.dart';
import 'poll_answer.dart';

class PollData {
  const PollData({
    required this.question,
    required this.instructions,
    required this.publicResults,
    required this.allowedVotes,
    required this.answers,
    this.canModify = false,
    this.userDidVote = false,
    this.totalVotes = 0,
    this.totalRespondents = 0,
    this.maximumAnswerVotes = 0,
  });

  final String question;
  final String instructions;
  final bool publicResults;
  final int allowedVotes;
  final List<PollAnswer> answers;
  final bool canModify;
  final bool userDidVote;
  final int totalVotes;
  final int totalRespondents;
  final int maximumAnswerVotes;

  static PollData? fromJson(Map<String, dynamic> j) {
    final answersJson = asMap(j['answers']);
    if (j['question'] == null || answersJson == null) return null;

    final computed = asMap(j['computed_values']);
    return PollData(
      question: asString(j['question']) ?? '',
      instructions: asString(j['instructions']) ?? '',
      publicResults: asBool(j['public_results']),
      allowedVotes: asInt(j['allowed_votes']) ?? 0,
      answers: [
        for (final e in answersJson.entries)
          if (e.value is Map)
            PollAnswer.fromJson(
              e.key,
              Map<String, dynamic>.from(e.value as Map),
            ),
      ],
      canModify: asBool(computed?['can_modify']),
      userDidVote: asBool(computed?['user_did_vote']),
      totalVotes: asInt(computed?['total_votes']) ?? 0,
      totalRespondents: asInt(computed?['total_respondents']) ?? 0,
      maximumAnswerVotes: asInt(computed?['maximum_answer_votes']) ?? 0,
    );
  }
}

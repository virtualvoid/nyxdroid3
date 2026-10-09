// author: juraj.suchan@gmail.com

part of 'compose_result.dart';

class ComposeVote extends ComposeResult {
  const ComposeVote(this.writeupId, this.type);
  final int writeupId;
  final VotingType type;
}

// author: juraj.suchan@gmail.com

import 'discussion_repository.dart';

class VotingResponse {
  const VotingResponse(this.result, [this.currentRating]);
  final VotingResult result;
  final int? currentRating;
}

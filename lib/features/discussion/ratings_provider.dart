// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import 'voting_info.dart';

typedef RatingKey = ({int discussionId, int writeupId});

final ratingsProvider = FutureProvider.autoDispose
    .family<VotingInfo, RatingKey>(
      (ref, key) => ref
          .watch(discussionRepositoryProvider)
          .getRatings(key.discussionId, key.writeupId),
    );

// author: juraj.suchan@gmail.com

import '../../core/models/writeup.dart';

class ComposeArgs {
  const ComposeArgs({
    required this.discussionId,
    required this.discussionName,
    this.replying = const [],
  });

  final int discussionId;
  final String discussionName;

  final List<Writeup> replying;
}

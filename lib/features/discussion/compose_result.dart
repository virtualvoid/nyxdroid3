// author: juraj.suchan@gmail.com

import '../../core/models/writeup.dart';

export '../compose/compose_base.dart';

part 'compose_sent.dart';
part 'compose_vote.dart';

sealed class ComposeResult {
  const ComposeResult();
}

// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../core/models/poll_answer.dart';
import '../../core/models/poll_data.dart';

class PollAnswers extends StatelessWidget {
  const PollAnswers({super.key, required this.poll, this.onVote});

  final PollData poll;
  final void Function(String answerKey)? onVote;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Column(children: [for (final a in poll.answers) _row(context, a)]),
  );

  Widget _row(BuildContext context, PollAnswer a) {
    final scheme = Theme.of(context).colorScheme;
    final percentage = poll.totalVotes == 0
        ? 0.0
        : a.respondentsCount / poll.totalVotes * 100.0;

    final button = Visibility(
      visible: !poll.userDidVote || a.isMyVote,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: FilledButton.tonal(
          key: Key('poll_answer_${a.key}'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(40, 36),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          onPressed: poll.userDidVote || onVote == null
              ? null
              : () => onVote!(a.key),
          child: Text(a.key),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          button,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poll.userDidVote
                      ? '${a.answer} ${percentage.toStringAsFixed(1)}% (${a.respondentsCount})'
                      : a.answer,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: a.isMyVote
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (poll.userDidVote)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        key: Key('poll_bar_${a.key}'),
                        value: percentage / 100,
                        minHeight: 8,
                        color: a.isMyVote ? scheme.primary : scheme.outline,
                        backgroundColor: scheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';
import '../../core/models/writeup.dart';

class VoteBar extends StatelessWidget {
  const VoteBar({
    super.key,
    required this.writeup,
    required this.appearance,
    this.onVote,
  });

  final Writeup writeup;
  final Appearance appearance;
  final void Function(VotingType type)? onVote;

  @override
  Widget build(BuildContext context) {
    final ap = appearance;
    final wu = writeup;
    final scheme = Theme.of(context).colorScheme;
    final positive = wu.myRating == VotingType.positive.value;
    final negative = wu.myRating.startsWith('negative');

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          key: const Key('wu_votes_area'),
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: !wu.isMine,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: IconButton(
                  key: const Key('wu_voteup'),
                  constraints: const BoxConstraints.tightFor(
                    width: 48,
                    height: 48,
                  ),
                  iconSize: 22,
                  icon: Icon(
                    positive ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                    color: positive
                        ? ap.votePositiveColor
                        : scheme.onSurfaceVariant,
                  ),
                  onPressed: onVote == null
                      ? null
                      : () => onVote!(VotingType.positive),
                ),
              ),
              if (wu.rating != 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${wu.rating}',
                    key: const Key('wu_rating'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: wu.rating < 0
                          ? ap.voteNegativeColor
                          : ap.votePositiveColor,
                    ),
                  ),
                ),
              Visibility(
                visible: !wu.isMine,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: IconButton(
                  key: const Key('wu_votedown'),
                  constraints: const BoxConstraints.tightFor(
                    width: 48,
                    height: 48,
                  ),
                  iconSize: 22,
                  icon: Icon(
                    negative ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
                    color: negative
                        ? ap.voteNegativeColor
                        : scheme.onSurfaceVariant,
                  ),
                  onPressed: onVote == null
                      ? null
                      : () => onVote!(VotingType.negative),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

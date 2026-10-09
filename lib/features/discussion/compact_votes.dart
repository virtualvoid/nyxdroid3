// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';
import '../../core/models/writeup.dart';

class CompactVotes extends StatelessWidget {
  const CompactVotes({
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

    Widget button(Key key, IconData icon, Color color, VotingType type) =>
        IconButton(
          key: key,
          padding: EdgeInsets.zero,
          iconSize: 18,
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: Icon(icon, color: color),
          onPressed: onVote == null ? null : () => onVote!(type),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!wu.isMine)
          button(
            const Key('wu_voteup'),
            positive ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
            positive ? ap.votePositiveColor : scheme.onSurfaceVariant,
            VotingType.positive,
          ),
        if (wu.rating != 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${wu.rating}',
              key: const Key('wu_rating'),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: wu.rating < 0
                    ? ap.voteNegativeColor
                    : ap.votePositiveColor,
              ),
            ),
          ),
        if (!wu.isMine)
          button(
            const Key('wu_votedown'),
            negative ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
            negative ? ap.voteNegativeColor : scheme.onSurfaceVariant,
            VotingType.negative,
          ),
      ],
    );
  }
}

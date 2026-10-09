// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/avatar.dart';

class RatingsColumn extends StatelessWidget {
  const RatingsColumn({
    super.key,
    required this.sign,
    required this.nicks,
    required this.empty,
  });

  final String sign;
  final List<String> nicks;
  final String empty;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        nicks.isEmpty ? empty : '$sign${nicks.length}',
        key: Key('ratings_count_$sign'),
        textAlign: TextAlign.center,
      ),
      for (final nick in nicks)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              NickAvatar(nick: nick, size: 28),
              const SizedBox(width: 6),
              Expanded(child: Text(nick, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
    ],
  );
}

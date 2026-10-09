// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/avatar.dart';
import '../../app/widgets/feed_card.dart';
import '../../core/format.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({
    super.key,
    required this.nick,
    required this.time,
    required this.child,
    this.onTap,
  });

  final String nick;
  final DateTime? time;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FeedCard(
      onTap: onTap,
      accent: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NickAvatar(nick: nick, size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: nick,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: time == null ? '' : formatDateTime(time!),
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

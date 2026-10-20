// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/models/user_activity.dart';
import '../../core/relative_time.dart';
import '../../l10n/app_localizations.dart';
import '../appearance.dart';

class EntryHeader extends StatelessWidget {
  const EntryHeader({
    super.key,
    required this.nick,
    required this.time,
    required this.unread,
    required this.appearance,
    required this.now,
    this.location,
    this.mirrored = false,
    this.stacked = false,
  });

  final String nick;
  final DateTime? time;
  final bool unread;
  final Appearance appearance;
  final DateTime now;
  final UserActivity? location;
  final bool mirrored;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ap = appearance;
    final customUnread = ap.entryUnreadColor != null;
    final color = customUnread && unread ? ap.entryUnreadColor : null;

    final nickText = Expanded(
      child: Text(
        nick,
        key: const Key('entry_nick'),
        textAlign: mirrored ? TextAlign.end : TextAlign.start,
        style: TextStyle(
          fontSize: ap.fontSize,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
    final timeText = Text(
      time == null ? '' : formatDateTime(time!),
      style: TextStyle(fontSize: 10, color: color),
    );

    final mark = Opacity(
      opacity: !customUnread && unread ? 1 : 0,
      child: Icon(
        Icons.fiber_manual_record,
        key: const Key('entry_unread_mark'),
        size: 12,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    final loc = location;
    final locationText = loc != null && loc.isValid
        ? Text(
            loc.location == null
                ? '[${relativeTime(l10n, loc.lastActivity!, now)}]'
                : '[${relativeTime(l10n, loc.lastActivity!, now)}] ${loc.location}',
            textAlign: mirrored ? TextAlign.end : TextAlign.start,
            maxLines: stacked ? 1 : null,
            overflow: stacked ? TextOverflow.ellipsis : null,
            style: const TextStyle(fontSize: 8),
          )
        : null;

    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [nickText, mark]),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [timeText, ?locationText],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: mirrored
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          children: mirrored
              ? [mark, timeText, const SizedBox(width: 6), nickText]
              : [nickText, timeText, mark],
        ),
        ?locationText,
      ],
    );
  }
}

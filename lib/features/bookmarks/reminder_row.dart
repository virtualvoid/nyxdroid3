// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';
import '../../core/format.dart';
import '../../core/models/bookmark_reminder.dart';
import 'reply_badge.dart';
import 'row_frame.dart';

class ReminderRow extends StatelessWidget {
  const ReminderRow({
    super.key,
    required this.reminder,
    required this.isSingle,
    required this.appearance,
    this.onTap,
  });

  final BookmarkReminder reminder;
  final bool isSingle;
  final Appearance appearance;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = isSingle
        ? reminder.name
        : '${reminder.time == null ? '' : formatDateTime(reminder.time!)} ${reminder.nick}';
    return InkWell(
      onTap: onTap,
      child: RowFrame(
        appearance: appearance,
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: Icon(
                Icons.alarm,
                size: 18,
                color: scheme.tertiary,
                key: const Key('reminder_icon'),
              ),
            ),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: appearance.fontSize,
                  color: appearance.bookmarkReadColor,
                ),
              ),
            ),
            if (isSingle && reminder.replies > 0) ...[
              const SizedBox(width: 8),
              ReplyBadge(
                count: reminder.replies,
                fontSize: appearance.fontSize,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

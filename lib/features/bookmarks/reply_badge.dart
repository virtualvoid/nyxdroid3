// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class ReplyBadge extends StatelessWidget {
  const ReplyBadge({
    super.key,
    required this.count,
    required this.fontSize,
    this.compact = false,
  });

  final int count;
  final double fontSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: AppLocalizations.of(context).replyBadge(count),
      child: Container(
        key: const Key('reply_badge'),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: compact ? 0 : 2),
        decoration: BoxDecoration(
          color: scheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.reply,
              size: fontSize,
              color: scheme.onTertiaryContainer,
            ),
            const SizedBox(width: 3),
            Text(
              '$count',
              key: const Key('reply_badge_text'),
              style: TextStyle(
                fontSize: fontSize - 2,
                fontWeight: FontWeight.w700,
                color: scheme.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

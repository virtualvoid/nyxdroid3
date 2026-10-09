// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class UnreadBadge extends StatelessWidget {
  const UnreadBadge({
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
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: compact ? 40 : 48,
      child: count > 0
          ? Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: compact ? 0 : 2,
                  ),
                  constraints: const BoxConstraints(minWidth: 28),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count',
                    key: const Key('unread_badge_text'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize - 2,
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

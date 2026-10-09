// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';
import '../../l10n/app_localizations.dart';

class HistoryDayHeader extends StatelessWidget {
  const HistoryDayHeader({
    super.key,
    required this.day,
    required this.now,
    required this.appearance,
  });

  final DateTime? day;
  final DateTime now;
  final Appearance appearance;

  String label(AppLocalizations l10n) {
    final d = day;
    if (d == null) return l10n.historyEarlier;
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return l10n.historyToday;
    if (diff == 1) return l10n.historyYesterday;
    return '${d.day}.${d.month}.${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16 + appearance.bookmarkPadding, 16, 4),
      child: Row(
        children: [
          Text(
            label(l10n).toUpperCase(),
            key: const Key('history_day_label'),
            style: TextStyle(
              fontSize: appearance.fontSize - 2,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(color: scheme.outlineVariant.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}

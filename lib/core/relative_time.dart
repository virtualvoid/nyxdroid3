// author: juraj.suchan@gmail.com

import '../l10n/app_localizations.dart';
import 'format.dart';

String relativeTime(AppLocalizations l10n, DateTime time, DateTime now) {
  final diff = now.difference(time);
  if (diff.isNegative) return formatDateTime(time);

  if (diff.inMinutes < 1) return l10n.relativeSeconds(diff.inSeconds);
  if (diff.inHours < 1) return l10n.relativeMinutes(diff.inMinutes);
  if (diff.inDays < 1) return l10n.relativeHours(diff.inHours);
  if (diff.inDays < 7) return l10n.relativeDays(diff.inDays);
  return '${time.day}.${time.month}.${time.year}';
}

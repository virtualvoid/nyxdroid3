// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

class NotificationsBadgeAction extends ConsumerWidget {
  const NotificationsBadgeAction({
    super.key,
    required this.unread,
    required this.onPressed,
  });

  final int unread;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      appPrefsProvider.select((p) => p.notificationBulb),
    );
    if (!enabled || unread <= 0) return const SizedBox.shrink();
    return IconButton(
      key: const Key('notifications_badge'),
      tooltip: AppLocalizations.of(context).menuNotifications,
      icon: Badge(
        label: Text('$unread'),
        child: const Icon(Icons.lightbulb_outline),
      ),
      onPressed: onPressed,
    );
  }
}

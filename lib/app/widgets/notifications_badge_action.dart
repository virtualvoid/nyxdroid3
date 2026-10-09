// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class NotificationsBadgeAction extends StatelessWidget {
  const NotificationsBadgeAction({
    super.key,
    required this.unread,
    required this.onPressed,
  });

  final int unread;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (unread <= 0) return const SizedBox.shrink();
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

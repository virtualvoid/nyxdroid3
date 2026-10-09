// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class MailBadgeAction extends StatelessWidget {
  const MailBadgeAction({
    super.key,
    required this.unreadMail,
    required this.onPressed,
  });

  final int unreadMail;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (unreadMail <= 0) return const SizedBox.shrink();
    return IconButton(
      key: const Key('mail_badge'),
      tooltip: AppLocalizations.of(context).menuMail,
      icon: Badge(
        label: Text('$unreadMail'),
        child: const Icon(Icons.mail_outline),
      ),
      onPressed: onPressed,
    );
  }
}

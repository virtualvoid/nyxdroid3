// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class RefreshAction extends StatelessWidget {
  const RefreshAction({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    key: const Key('refresh'),
    tooltip: AppLocalizations.of(context).refresh,
    icon: const Icon(Icons.refresh),
    onPressed: onPressed,
  );
}

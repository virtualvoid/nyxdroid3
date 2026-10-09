// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        Image.asset(
          'assets/splash/splash_logo.png',
          key: const Key('auth_logo'),
          width: 88,
          height: 88,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.appName,
          key: const Key('auth_title'),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

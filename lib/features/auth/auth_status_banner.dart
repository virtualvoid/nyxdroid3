// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import 'auth_controller.dart';

class AuthStatusBanner extends StatelessWidget {
  const AuthStatusBanner({
    super.key,
    required this.message,
    required this.text,
  });

  final AuthMessage message;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground, icon) = switch (message) {
      AuthMessage.instructions => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
        Icons.info_outline,
      ),
      AuthMessage.success => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        Icons.check_circle_outline,
      ),
      AuthMessage.error => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        Icons.error_outline,
      ),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(message),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: foreground,
              key: Key('auth_banner_${message.name}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                key: const Key('authorization_result'),
                style: TextStyle(color: foreground, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

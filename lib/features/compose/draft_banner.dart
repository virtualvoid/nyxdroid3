// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class DraftBanner extends StatelessWidget {
  const DraftBanner({
    super.key,
    required this.message,
    required this.discardLabel,
    required this.onDiscard,
  });

  final String message;
  final String discardLabel;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
        child: Row(
          children: [
            Icon(Icons.edit_note, size: 20, color: scheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                key: const Key('draft_banner_text'),
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ),
            TextButton(
              key: const Key('draft_discard'),
              onPressed: onDiscard,
              child: Text(discardLabel),
            ),
          ],
        ),
      ),
    );
  }
}

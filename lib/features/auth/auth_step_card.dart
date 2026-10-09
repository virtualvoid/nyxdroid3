// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class AuthStepCard extends StatelessWidget {
  const AuthStepCard({
    super.key,
    required this.step,
    required this.title,
    required this.child,
    this.active = true,
    this.done = false,
  });

  final int step;
  final String title;
  final Widget child;
  final bool active;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badgeColor = done || active
        ? scheme.primary
        : scheme.surfaceContainerHighest;
    final badgeText = done || active
        ? scheme.onPrimary
        : scheme.onSurfaceVariant;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: active || done ? 1 : 0.55,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    key: Key('auth_step_$step'),
                    radius: 14,
                    backgroundColor: badgeColor,
                    child: done
                        ? Icon(Icons.check, size: 16, color: badgeText)
                        : Text(
                            '$step',
                            style: TextStyle(
                              color: badgeText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

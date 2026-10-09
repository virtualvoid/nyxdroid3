// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.accent = false,
    this.highlighted = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool accent;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = highlighted
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.14),
            scheme.surfaceContainerHigh,
          )
        : scheme.surfaceContainerHigh;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Stack(
            children: [
              if (accent)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 4,
                  child: ColoredBox(
                    key: const Key('feed_card_accent'),
                    color: scheme.primary,
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(accent ? 16 : 12, 10, 12, 10),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

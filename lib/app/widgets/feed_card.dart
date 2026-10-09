// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';

class FeedCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final compact = ref.watch(appearanceProvider.select((a) => a.compact));
    final scheme = Theme.of(context).colorScheme;
    final color = highlighted
        ? Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.14),
            scheme.surfaceContainerHigh,
          )
        : scheme.surfaceContainerHigh;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 2 : 4,
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(compact ? 12 : 16),
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
                padding: EdgeInsets.fromLTRB(
                  accent ? 16 : (compact ? 10 : 12),
                  compact ? 6 : 10,
                  compact ? 10 : 12,
                  compact ? 6 : 10,
                ),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

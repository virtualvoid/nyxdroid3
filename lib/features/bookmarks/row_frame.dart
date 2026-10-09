// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';

class RowFrame extends StatelessWidget {
  const RowFrame({
    super.key,
    required this.appearance,
    required this.child,
    this.background,
  });

  final Appearance appearance;
  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: background,
        border: Border(
          bottom: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      constraints: const BoxConstraints(minHeight: 48),
      padding: EdgeInsets.symmetric(
        horizontal: 12 + appearance.bookmarkPadding,
        vertical: appearance.bookmarkPadding,
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}

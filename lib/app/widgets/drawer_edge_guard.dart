// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class DrawerEdgeGuard extends StatelessWidget {
  const DrawerEdgeGuard({super.key, required this.child});

  final Widget child;

  static const margin = 16.0;

  Widget _strip({double? left, double? right, required double width}) =>
      Positioned(
        left: left,
        right: right,
        top: 0,
        bottom: 0,
        width: width,
        child: GestureDetector(
          key: Key(left != null ? 'edge_guard_left' : 'edge_guard_right'),
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (_) {},
        ),
      );

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.systemGestureInsetsOf(context);
    return Stack(
      children: [
        Positioned.fill(child: child),
        if (insets.left > 0) _strip(left: 0, width: insets.left + margin),
        if (insets.right > 0) _strip(right: 0, width: insets.right + margin),
      ],
    );
  }
}

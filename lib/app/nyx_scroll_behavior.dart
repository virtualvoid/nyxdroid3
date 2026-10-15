// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class NyxScrollBehavior extends MaterialScrollBehavior {
  const NyxScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (axisDirectionToAxis(details.direction) == Axis.horizontal) {
      return child;
    }
    return Scrollbar(
      controller: details.controller,
      interactive: true,
      child: child,
    );
  }
}

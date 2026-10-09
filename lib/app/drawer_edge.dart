// author: juraj.suchan@gmail.com

import 'package:flutter/widgets.dart';

const drawerWideFraction = 0.35;
const drawerNarrowFraction = 0.15;

double drawerEdgeDragWidth(
  BuildContext context, {
  double fraction = drawerWideFraction,
}) => MediaQuery.sizeOf(context).width * fraction;

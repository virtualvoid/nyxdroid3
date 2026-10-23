// author: juraj.suchan@gmail.com

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/widgets.dart';

const drawerWideFraction = 0.35;
const drawerNarrowFraction = 0.15;

double drawerEdgeDragWidth(
  BuildContext context, {
  double fraction = drawerWideFraction,
}) => defaultTargetPlatform == TargetPlatform.iOS
    ? 0
    : MediaQuery.sizeOf(context).width * fraction;

// author: juraj.suchan@gmail.com

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exitAppProvider = Provider<Future<void> Function()>(
  (ref) =>
      () => SystemNavigator.pop(),
);

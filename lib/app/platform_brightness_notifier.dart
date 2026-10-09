// author: juraj.suchan@gmail.com

import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlatformBrightnessNotifier extends Notifier<Brightness> {
  @override
  Brightness build() => PlatformDispatcher.instance.platformBrightness;

  void set(Brightness value) => state = value;
}

final platformBrightnessProvider =
    NotifierProvider<PlatformBrightnessNotifier, Brightness>(
      PlatformBrightnessNotifier.new,
    );

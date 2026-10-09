// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

const resumeRefreshAfter = Duration(seconds: 30);

final appClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

class AppResumeNotifier extends Notifier<int> {
  DateTime? _pausedAt;

  @override
  int build() => 0;

  void paused() => _pausedAt ??= ref.read(appClockProvider)();

  void resumed() {
    final pausedAt = _pausedAt;
    _pausedAt = null;
    if (pausedAt == null) return;
    final away = ref.read(appClockProvider)().difference(pausedAt);
    if (away >= resumeRefreshAfter) state++;
  }
}

final appResumeProvider = NotifierProvider<AppResumeNotifier, int>(
  AppResumeNotifier.new,
);

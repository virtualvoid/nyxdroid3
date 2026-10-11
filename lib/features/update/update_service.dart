// author: juraj.suchan@gmail.com

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_resume_notifier.dart';
import '../../app/root_navigator_key.dart';
import '../../core/prefs/app_prefs.dart';
import '../../core/providers.dart';
import '../about/app_version_provider.dart';
import 'app_release.dart';
import 'update_dialog.dart';
import 'update_repository.dart';
import 'version_compare.dart';

const updateCheckInterval = Duration(hours: 24);

class UpdateService {
  UpdateService(this._ref);

  final Ref _ref;

  bool get supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<AppRelease?> _newer({required bool respectSkipped}) async {
    final current = await _ref.read(appVersionProvider.future);
    if (current.isEmpty) return null;
    final release = await _ref.read(updateRepositoryProvider).latest();
    await _ref
        .read(appPrefsProvider.notifier)
        .setString(
          AppPrefs.kUpdateLastCheck,
          _ref.read(appClockProvider)().millisecondsSinceEpoch.toString(),
        );
    if (release == null || !isNewerVersion(release.version, current)) {
      return null;
    }
    if (respectSkipped &&
        _ref.read(appPrefsProvider).updateSkippedVersion == release.version) {
      return null;
    }
    return release;
  }

  Future<AppRelease?> checkNow() => _newer(respectSkipped: false);

  Future<void> skip(AppRelease release) => _ref
      .read(appPrefsProvider.notifier)
      .setString(AppPrefs.kUpdateSkipped, release.version);

  Future<void> show(BuildContext context, AppRelease release) async {
    final current = await _ref.read(appVersionProvider.future);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => UpdateDialog(
        release: release,
        currentVersion: current,
        onSkip: () => skip(release),
      ),
    );
  }

  Future<void> checkInBackground() async {
    if (!supported) return;
    final prefs = _ref.read(appPrefsProvider);
    if (!prefs.updateCheck) return;
    final last = prefs.updateLastCheck;
    if (last != null &&
        _ref.read(appClockProvider)().difference(last) < updateCheckInterval) {
      return;
    }
    try {
      final release = await _newer(respectSkipped: true);
      if (release == null) return;
      final context = _ref.read(rootNavigatorKeyProvider).currentContext;
      if (context == null || !context.mounted) return;
      await show(context, release);
    } catch (_) {}
  }
}

final updateServiceProvider = Provider<UpdateService>(UpdateService.new);

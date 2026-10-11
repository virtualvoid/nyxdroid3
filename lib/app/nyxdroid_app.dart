// author: juraj.suchan@gmail.com

import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/prefs/locale_pref.dart';
import '../core/prefs/theme_mode_pref.dart';
import '../core/providers.dart';
import '../features/auth/authorized_notifier.dart';
import '../features/notifications/status_counts_provider.dart';
import '../features/push/push_service.dart';
import '../features/share/share_service.dart';
import '../features/update/update_service.dart';
import '../l10n/app_localizations.dart';
import 'app_resume_notifier.dart';
import 'nyx_theme.dart';
import 'platform_brightness_notifier.dart';
import 'router.dart';

class NyxdroidApp extends ConsumerStatefulWidget {
  const NyxdroidApp({super.key});

  @override
  ConsumerState<NyxdroidApp> createState() => _NyxdroidAppState();
}

class _NyxdroidAppState extends ConsumerState<NyxdroidApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(shareServiceProvider).start();
    ref.listenManual<int>(appResumeProvider, (_, _) {
      ref.invalidate(statusCountsProvider);
      ref.read(updateServiceProvider).checkInBackground();
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) ref.read(updateServiceProvider).checkInBackground();
    });
    ref.listenManual<bool>(authorizedProvider, (_, authorized) {
      final push = ref.read(pushServiceProvider);
      authorized ? push.start() : push.stop();
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final resume = ref.read(appResumeProvider.notifier);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        resume.paused();
      case AppLifecycleState.resumed:
        resume.resumed();
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void didChangePlatformBrightness() {
    ref
        .read(platformBrightnessProvider.notifier)
        .set(PlatformDispatcher.instance.platformBrightness);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(appPrefsProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: NyxTheme.light(),
      darkTheme: NyxTheme.dark(),
      themeMode: themeModeFromPref(prefs.themeMode),
      locale: localeFromPref(prefs.language),
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

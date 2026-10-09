// author: juraj.suchan@gmail.com

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/auth/auth_store.dart';
import 'core/firebase_bootstrap.dart';
import 'app/nyxdroid_app.dart';
import 'core/prefs/app_prefs.dart';
import 'core/providers.dart';
import 'core/telemetry/firebase_telemetry_gateway.dart';
import 'core/telemetry/telemetry_gateway.dart';
import 'features/push/firebase_push_gateway.dart';
import 'features/push/push_gateway.dart';
import 'features/share/method_channel_share_gateway.dart';
import 'features/share/share_gateway.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authStore = AuthStore();
  await authStore.load();
  final prefs = await SharedPreferences.getInstance();
  final appPrefs = AppPrefs(prefs);
  final firebaseReady = await initializeFirebase(
    nick: authStore.nick,
    crashReporting: appPrefs.crashReportingEnabled,
    analytics: appPrefs.analyticsEnabled,
  );

  runApp(
    ProviderScope(
      overrides: [
        authStoreProvider.overrideWithValue(authStore),
        sharedPreferencesProvider.overrideWithValue(prefs),
        if (Platform.isAndroid)
          shareGatewayProvider.overrideWithValue(MethodChannelShareGateway()),
        if (firebaseReady) ...[
          pushGatewayProvider.overrideWithValue(FirebasePushGateway()),
          telemetryGatewayProvider.overrideWithValue(
            FirebaseTelemetryGateway(),
          ),
        ],
      ],
      child: const NyxdroidApp(),
    ),
  );
}

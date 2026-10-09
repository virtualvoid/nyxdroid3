// author: juraj.suchan@gmail.com

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

Future<bool> initializeFirebase({
  String? nick,
  bool crashReporting = true,
  bool analytics = true,
}) async {
  try {
    await Firebase.initializeApp();

    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(crashReporting);
    if (crashReporting && nick != null && nick.isNotEmpty) {
      await crashlytics.setUserIdentifier(nick);
    }
    FlutterError.onError = crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };

    final analyticsInstance = FirebaseAnalytics.instance;
    await analyticsInstance.setAnalyticsCollectionEnabled(analytics);
    if (analytics && nick != null && nick.isNotEmpty) {
      await analyticsInstance.setUserId(id: nick);
    }

    return true;
  } catch (e) {
    debugPrint('firebase: $e');
    return false;
  }
}

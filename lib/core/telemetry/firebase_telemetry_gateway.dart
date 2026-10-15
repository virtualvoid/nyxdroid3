// author: juraj.suchan@gmail.com

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'telemetry_gateway.dart';

class FirebaseTelemetryGateway implements TelemetryGateway {
  @override
  Future<void> setCrashReporting(bool enabled, {String? nick}) async {
    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(enabled);
    await crashlytics.setUserIdentifier(enabled ? (nick ?? '') : '');
  }

  @override
  Future<void> setAnalytics(bool enabled, {String? nick}) async {
    final analytics = FirebaseAnalytics.instance;
    await analytics.setAnalyticsCollectionEnabled(enabled);
    if (enabled) {
      if (nick != null && nick.isNotEmpty) await analytics.setUserId(id: nick);
    } else {
      await analytics.setUserId(id: null);
      await analytics.resetAnalyticsData();
    }
  }

  @override
  Future<void> logScreen(String name) async {
    try {
      await FirebaseAnalytics.instance.logScreenView(screenName: name);
    } catch (_) {}
  }
}

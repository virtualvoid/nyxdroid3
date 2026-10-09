// author: juraj.suchan@gmail.com

import 'telemetry_gateway.dart';

class NoopTelemetryGateway implements TelemetryGateway {
  @override
  Future<void> setCrashReporting(bool enabled, {String? nick}) async {}

  @override
  Future<void> setAnalytics(bool enabled, {String? nick}) async {}
}

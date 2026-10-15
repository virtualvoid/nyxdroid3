// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'noop_telemetry_gateway.dart';

abstract class TelemetryGateway {
  Future<void> setCrashReporting(bool enabled, {String? nick});
  Future<void> setAnalytics(bool enabled, {String? nick});
  Future<void> logScreen(String name);
}

final telemetryGatewayProvider = Provider<TelemetryGateway>(
  (ref) => NoopTelemetryGateway(),
);

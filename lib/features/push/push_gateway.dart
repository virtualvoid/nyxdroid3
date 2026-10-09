// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'noop_push_gateway.dart';
import 'push_message.dart';

abstract class PushGateway {
  Future<bool> requestPermission();
  Future<String?> getToken();
  Future<void> deleteToken();
  Stream<String> get onTokenRefresh;
  Stream<PushMessage> get onMessage;
  Stream<PushMessage> get onOpened;
  Future<PushMessage?> getInitialMessage();
}

final pushGatewayProvider = Provider<PushGateway>((ref) => NoopPushGateway());

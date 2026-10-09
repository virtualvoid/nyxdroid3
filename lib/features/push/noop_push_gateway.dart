// author: juraj.suchan@gmail.com

import 'push_gateway.dart';
import 'push_message.dart';

class NoopPushGateway implements PushGateway {
  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> deleteToken() async {}

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Stream<PushMessage> get onMessage => const Stream.empty();

  @override
  Stream<PushMessage> get onOpened => const Stream.empty();

  @override
  Future<PushMessage?> getInitialMessage() async => null;
}

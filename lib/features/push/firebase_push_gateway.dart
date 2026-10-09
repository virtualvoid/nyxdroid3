// author: juraj.suchan@gmail.com

import 'package:firebase_messaging/firebase_messaging.dart';

import 'push_gateway.dart';
import 'push_message.dart';

class FirebasePushGateway implements PushGateway {
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  static PushMessage _map(RemoteMessage m) =>
      PushMessage(type: m.data['type']?.toString());

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getToken() => _messaging.getToken();

  @override
  Future<void> deleteToken() => _messaging.deleteToken();

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Stream<PushMessage> get onMessage => FirebaseMessaging.onMessage.map(_map);

  @override
  Stream<PushMessage> get onOpened =>
      FirebaseMessaging.onMessageOpenedApp.map(_map);

  @override
  Future<PushMessage?> getInitialMessage() async {
    final m = await _messaging.getInitialMessage();
    return m == null ? null : _map(m);
  }
}

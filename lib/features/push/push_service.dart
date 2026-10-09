// author: juraj.suchan@gmail.com

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/router.dart';
import '../../core/providers.dart';
import '../notifications/status_counts_provider.dart';
import 'push_gateway.dart';
import 'push_message.dart';

class PushService {
  PushService(this._ref);

  final Ref _ref;
  final _events = StreamController<PushMessage>.broadcast();
  final List<StreamSubscription<Object?>> _subscriptions = [];
  bool _started = false;

  PushGateway get _gateway => _ref.read(pushGatewayProvider);

  Stream<PushMessage> get events => _events.stream;

  bool get started => _started;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    _subscriptions
      ..add(_gateway.onMessage.listen(_onForeground))
      ..add(_gateway.onOpened.listen(_openFrom))
      ..add(_gateway.onTokenRefresh.listen(_register));

    final initial = await _guard(_gateway.getInitialMessage);
    if (initial != null) _openFrom(initial);

    if (_ref.read(appPrefsProvider).notificationsEnabled) {
      await enable();
    } else {
      await disable();
    }
  }

  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    for (final s in _subscriptions) {
      await s.cancel();
    }
    _subscriptions.clear();
    await _guard(_gateway.deleteToken);
  }

  Future<void> enable() async {
    await _guard(_gateway.requestPermission);
    final token = await _guard(_gateway.getToken);
    if (kDebugMode) debugPrint('push: fcm token $token');
    if (token != null) await _register(token);
  }

  Future<void> disable() async {
    await _guard(_gateway.deleteToken);
    final authToken = _ref.read(authStoreProvider).token;
    if (_ref.read(authStoreProvider).isAuthorized && authToken != null) {
      await _guard(
        () => _ref.read(authRepositoryProvider).unregisterPush(authToken),
      );
    }
  }

  Future<void> setEnabled(bool enabled) => enabled ? enable() : disable();

  Future<void> _register(String fcmToken) async {
    final store = _ref.read(authStoreProvider);
    final authToken = store.token;
    if (!store.isAuthorized || authToken == null) return;
    await _guard(
      () => _ref.read(authRepositoryProvider).registerPush(authToken, fcmToken),
    );
  }

  void _onForeground(PushMessage message) {
    _ref.invalidate(statusCountsProvider);
    _events.add(message);
  }

  void _openFrom(PushMessage message) {
    if (!_ref.read(authStoreProvider).isAuthorized) return;
    final router = _ref.read(routerProvider);
    if (message.isNewMail) {
      router.go(Routes.mail);
    } else if (message.isReply) {
      router.go(Routes.notifications);
    }
  }

  Future<T?> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      debugPrint('push: $e');
      return null;
    }
  }

  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _events.close();
  }
}

final pushServiceProvider = Provider<PushService>((ref) {
  final service = PushService(ref);
  ref.onDispose(service.dispose);
  return service;
});

final pushEventsProvider = StreamProvider<PushMessage>(
  (ref) => ref.watch(pushServiceProvider).events,
);

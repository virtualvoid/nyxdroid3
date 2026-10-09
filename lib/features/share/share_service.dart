// author: juraj.suchan@gmail.com

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pending_share_notifier.dart';
import 'share_gateway.dart';
import 'shared_content.dart';

class ShareService {
  ShareService(this._ref);

  final Ref _ref;
  StreamSubscription<SharedContent>? _subscription;

  Future<void> start() async {
    if (_subscription != null) return;
    final gateway = _ref.read(shareGatewayProvider);
    _subscription = gateway.onShare.listen(_accept);
    final initial = await gateway.getInitial();
    if (initial != null) _accept(initial);
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _accept(SharedContent content) =>
      _ref.read(pendingShareProvider.notifier).set(content);
}

final shareServiceProvider = Provider<ShareService>((ref) {
  final service = ShareService(ref);
  ref.onDispose(service.stop);
  return service;
});

// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'noop_share_gateway.dart';
import 'shared_content.dart';

abstract class ShareGateway {
  Future<SharedContent?> getInitial();
  Stream<SharedContent> get onShare;
}

final shareGatewayProvider = Provider<ShareGateway>(
  (ref) => NoopShareGateway(),
);

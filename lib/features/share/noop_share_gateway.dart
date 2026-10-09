// author: juraj.suchan@gmail.com

import 'share_gateway.dart';
import 'shared_content.dart';

class NoopShareGateway implements ShareGateway {
  @override
  Future<SharedContent?> getInitial() async => null;

  @override
  Stream<SharedContent> get onShare => const Stream.empty();
}

// author: juraj.suchan@gmail.com

import 'dart:async';

import 'package:flutter/services.dart';

import 'share_gateway.dart';
import 'shared_content.dart';

class MethodChannelShareGateway implements ShareGateway {
  MethodChannelShareGateway({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(channelName) {
    _channel.setMethodCallHandler(_handle);
  }

  static const channelName = 'sk.virtualvoid.nyxdroid/share';

  final MethodChannel _channel;
  final _controller = StreamController<SharedContent>.broadcast();

  Future<Object?> _handle(MethodCall call) async {
    if (call.method == 'onShare') {
      final content = SharedContent.fromChannel(call.arguments);
      if (content != null) _controller.add(content);
    }
    return null;
  }

  @override
  Future<SharedContent?> getInitial() async {
    try {
      return SharedContent.fromChannel(
        await _channel.invokeMethod<Object?>('getInitialShare'),
      );
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  @override
  Stream<SharedContent> get onShare => _controller.stream;
}

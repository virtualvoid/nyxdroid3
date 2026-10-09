// author: juraj.suchan@gmail.com

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../compose/compose_controller_base.dart';
import '../compose/compose_state.dart';

class ComposeController extends ComposeControllerBase {
  ComposeController(this.discussionId);

  final int discussionId;

  @override
  Future<void> deliver(String text, MultipartFile? attachment) => ref
      .read(discussionRepositoryProvider)
      .sendWriteup(discussionId, text, attachment: attachment);
}

final composeControllerProvider = NotifierProvider.autoDispose
    .family<ComposeController, ComposeState, int>(ComposeController.new);

String replyTag(String nick, int writeupId) => '{reply $nick|$writeupId}: ';

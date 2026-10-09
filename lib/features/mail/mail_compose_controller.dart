// author: juraj.suchan@gmail.com

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../compose/compose_base.dart';
import '../compose/compose_controller_base.dart';
import '../compose/compose_state.dart';

class MailComposeController extends ComposeControllerBase {
  String recipient = '';

  @override
  SendOutcome? precheck() =>
      recipient.trim().isEmpty ? SendOutcome.noRecipient : null;

  @override
  Future<void> deliver(String text, MultipartFile? attachment) => ref
      .read(mailRepositoryProvider)
      .sendMail(recipient.trim(), text, attachment: attachment);
}

final mailComposeControllerProvider =
    NotifierProvider.autoDispose<MailComposeController, ComposeState>(
      MailComposeController.new,
    );

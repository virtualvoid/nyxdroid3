// author: juraj.suchan@gmail.com

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/attachment_file.dart';
import 'compose_base.dart';
import 'compose_state.dart';

abstract class ComposeControllerBase extends Notifier<ComposeState> {
  @override
  ComposeState build() => const ComposeState();

  Future<void> deliver(String text, MultipartFile? attachment);

  SendOutcome? precheck() => null;

  void setAttachment(String path, String name) {
    final ok = File(path).existsSync();
    state = ok
        ? state.copyWith(
            attachmentPath: path,
            attachmentName: name,
            clearProblem: true,
          )
        : state.copyWith(
            problem: AttachmentProblem.unreadable,
            clearAttachment: true,
          );
  }

  void removeAttachment() => state = state.copyWith(clearAttachment: true);

  Future<SendOutcome> send(String text) async {
    if (state.sending) return SendOutcome.failed;
    final pre = precheck();
    if (pre != null) return pre;
    if (text.isEmpty && !state.hasAttachment) return SendOutcome.empty;

    state = state.copyWith(sending: true, clearError: true);
    try {
      final path = state.attachmentPath;
      final attachment = path == null
          ? null
          : await attachmentFromPath(path, name: state.attachmentName);
      await deliver(text, attachment);
      state = state.copyWith(sending: false);
      return SendOutcome.sent;
    } catch (e) {
      state = state.copyWith(sending: false, error: e);
      return SendOutcome.failed;
    }
  }
}

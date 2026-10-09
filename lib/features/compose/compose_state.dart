// author: juraj.suchan@gmail.com

import 'compose_base.dart';

class ComposeState {
  const ComposeState({
    this.attachmentPath,
    this.attachmentName,
    this.sending = false,
    this.error,
    this.problem,
  });

  final String? attachmentPath;
  final String? attachmentName;
  final bool sending;
  final Object? error;
  final AttachmentProblem? problem;

  bool get hasAttachment => attachmentPath != null;

  ComposeState copyWith({
    String? attachmentPath,
    String? attachmentName,
    bool clearAttachment = false,
    bool? sending,
    Object? error,
    bool clearError = false,
    AttachmentProblem? problem,
    bool clearProblem = false,
  }) => ComposeState(
    attachmentPath: clearAttachment
        ? null
        : (attachmentPath ?? this.attachmentPath),
    attachmentName: clearAttachment
        ? null
        : (attachmentName ?? this.attachmentName),
    sending: sending ?? this.sending,
    error: clearError ? null : (error ?? this.error),
    problem: clearProblem ? null : (problem ?? this.problem),
  );
}

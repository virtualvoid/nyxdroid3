// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/conversation.dart';
import '../../core/models/mail.dart';
import 'mail_controller.dart';

class MailState {
  const MailState({
    this.mails = const [],
    this.conversations = const [],
    this.loading = false,
    this.loadingMore = false,
    this.reachedEnd = false,
    this.conversationsLoading = false,
    this.error,
    this.filterUser,
    this.filterText,
  });

  final List<Mail> mails;
  final List<Conversation> conversations;
  final bool loading;
  final bool loadingMore;
  final bool reachedEnd;
  final bool conversationsLoading;
  final Object? error;

  final String? filterUser;
  final String? filterText;

  bool get filtered =>
      (filterUser ?? '').isNotEmpty || (filterText ?? '').isNotEmpty;

  MailState copyWith({
    List<Mail>? mails,
    List<Conversation>? conversations,
    bool? loading,
    bool? loadingMore,
    bool? reachedEnd,
    bool? conversationsLoading,
    Object? error,
    bool clearError = false,
    String? filterUser,
    String? filterText,
    bool clearFilter = false,
  }) => MailState(
    mails: mails ?? this.mails,
    conversations: conversations ?? this.conversations,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    reachedEnd: reachedEnd ?? this.reachedEnd,
    conversationsLoading: conversationsLoading ?? this.conversationsLoading,
    error: clearError ? null : (error ?? this.error),
    filterUser: clearFilter ? null : (filterUser ?? this.filterUser),
    filterText: clearFilter ? null : (filterText ?? this.filterText),
  );
}

final mailControllerProvider = NotifierProvider<MailController, MailState>(
  MailController.new,
);

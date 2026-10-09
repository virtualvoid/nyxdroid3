// author: juraj.suchan@gmail.com

import '../../core/models/api_context.dart';
import '../../core/models/conversation.dart';
import '../../core/models/mail.dart';

class MailPage {
  const MailPage({
    this.mails = const [],
    this.conversations = const [],
    this.context,
  });

  final List<Mail> mails;
  final List<Conversation> conversations;
  final ApiContext? context;
}

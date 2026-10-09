// author: juraj.suchan@gmail.com

import '../../core/models/mail.dart';

class MailComposeArgs {
  const MailComposeArgs({
    this.recipient = '',
    this.replyTo,
    this.quoteReply = false,
  });

  final String recipient;

  final Mail? replyTo;

  final bool quoteReply;
}

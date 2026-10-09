// author: juraj.suchan@gmail.com

class PushMessage {
  const PushMessage({this.type});

  final String? type;

  static const newMail = 'new_mail';
  static const reply = 'reply';

  bool get isNewMail => type?.toLowerCase() == newMail;
  bool get isReply => type?.toLowerCase() == reply;
}

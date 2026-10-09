// author: juraj.suchan@gmail.com

class MailNotification {
  const MailNotification({this.count = 0, this.lastFrom});

  final int count;
  final String? lastFrom;

  bool get valid => count > 0 && lastFrom != null;
}

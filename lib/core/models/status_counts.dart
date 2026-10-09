// author: juraj.suchan@gmail.com

class StatusCounts {
  const StatusCounts({
    this.mail = 0,
    this.mailLastFrom,
    this.notifications = 0,
  });

  final int mail;
  final String? mailLastFrom;
  final int notifications;
}

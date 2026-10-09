// author: juraj.suchan@gmail.com

part 'discussion_link.dart';
part 'external_link.dart';
part 'image_link.dart';
part 'mail_link.dart';

sealed class LinkTarget {
  const LinkTarget();
}

LinkTarget classifyLink(String url) {
  if (_attachment.hasMatch(url)) return ImageLink(fixUrl(url));

  final post = _discussionPost.firstMatch(url);
  if (post != null) {
    return DiscussionLink(int.parse(post.group(1)!), int.parse(post.group(2)!));
  }

  final disc = _discussion.firstMatch(url);
  if (disc != null) return DiscussionLink(int.parse(disc.group(1)!));

  final mail = _mailReply.firstMatch(url);
  if (mail != null) return MailLink(int.parse(mail.group(1)!));

  return ExternalLink(fixUrl(url));
}

const _index = 'https://nyx.cz';

String fixUrl(String? url) {
  if (url == null) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  return '$_index$url';
}

final _attachment = RegExp(
  r'^.*(original)\.(jpg|jpeg|png|gif|webp)(\?.*)?$',
  caseSensitive: false,
);

final _discussionPost = RegExp(
  r'^.*/discussion/(\d+)/id/(\d+)$',
  caseSensitive: false,
);

final _discussion = RegExp(r'^.*/discussion/(\d+)$', caseSensitive: false);

final _mailReply = RegExp(r'^.*/mail/id/(\d+)$', caseSensitive: false);

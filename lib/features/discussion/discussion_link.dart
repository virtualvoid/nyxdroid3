// author: juraj.suchan@gmail.com

part of 'link_target.dart';

class DiscussionLink extends LinkTarget {
  const DiscussionLink(this.discussionId, [this.postId]);
  final int discussionId;
  final int? postId;
}

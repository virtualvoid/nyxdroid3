// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';
import '../../app/avatar.dart';
import '../../app/widgets/feed_card.dart';
import '../../core/format.dart';
import '../../core/models/notice.dart';
import '../discussion/content_html.dart';
import '../discussion/post_html.dart';

class NoticeTile extends StatelessWidget {
  const NoticeTile({
    super.key,
    required this.notice,
    required this.appearance,
    this.onTap,
    this.onLink,
  });

  final Notice notice;
  final Appearance appearance;
  final VoidCallback? onTap;
  final void Function(String url)? onLink;

  @override
  Widget build(BuildContext context) => switch (notice.type) {
    NoticeType.notice => _notice(context),
    NoticeType.reply => _reply(context),
    NoticeType.thumbs => _thumbs(context),
  };

  Widget _notice(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FeedCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NickAvatar(nick: notice.nick, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notice.nick,
                        key: const Key('notice_nick'),
                        style: TextStyle(
                          fontSize: appearance.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      notice.time == null ? '' : formatDateTime(notice.time!),
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                PostHtml(
                  prepareContent(notice.content),
                  appearance,
                  onLink: onLink,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reply(BuildContext context) => FeedCard(
    onTap: onTap,
    accent: true,
    highlighted: notice.isNew,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NickAvatar(nick: notice.nick, size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: PostHtml(
            prepareContent(notice.content),
            appearance,
            onLink: onLink,
          ),
        ),
        const SizedBox(width: 8),
        Opacity(
          opacity: notice.isNew ? 1 : 0,
          child: Icon(
            Icons.fiber_manual_record,
            key: const Key('notice_unread_mark'),
            size: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    ),
  );

  Widget _thumbs(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FeedCard(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: scheme.tertiaryContainer,
            child: Icon(
              Icons.thumb_up_alt_outlined,
              size: 18,
              color: scheme.onTertiaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '+${notice.thumbs}',
            key: const Key('notice_thumbs'),
            style: TextStyle(
              fontSize: appearance.fontSize + 2,
              fontWeight: FontWeight.bold,
              color: appearance.votePositiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

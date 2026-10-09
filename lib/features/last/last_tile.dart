// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';
import '../../app/avatar.dart';
import '../../app/widgets/feed_card.dart';
import '../../core/format.dart';
import '../../core/models/last_post.dart';
import '../../l10n/app_localizations.dart';
import '../discussion/content_html.dart';
import '../discussion/post_html.dart';

class LastTile extends StatelessWidget {
  const LastTile({
    super.key,
    required this.post,
    required this.appearance,
    this.onTap,
    this.onLink,
  });

  final LastPost post;
  final Appearance appearance;
  final VoidCallback? onTap;
  final void Function(String url)? onLink;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final wu = post.writeup;
    final ap = appearance;

    final body = hasSpoiler(wu.content)
        ? Text(
            l10n.spoilerAlert,
            key: const Key('last_spoiler'),
            style: TextStyle(
              fontSize: ap.fontSize,
              fontStyle: FontStyle.italic,
              color: scheme.onSurfaceVariant,
            ),
          )
        : PostHtml(prepareContent(wu.content), ap, onLink: onLink);

    return FeedCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NickAvatar(nick: wu.nick, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        wu.nick,
                        key: const Key('last_nick'),
                        style: TextStyle(
                          fontSize: ap.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      wu.time == null ? '' : formatDateTime(wu.time!),
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (post.discussionName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: 13,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.discussionName,
                          key: const Key('last_discussion'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                body,
                if (wu.rating != 0)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${wu.rating}',
                          key: const Key('last_rating'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: wu.rating < 0
                                ? ap.voteNegativeColor
                                : ap.votePositiveColor,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

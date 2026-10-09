// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';
import '../../core/models/bookmark.dart';
import 'reply_badge.dart';
import 'row_frame.dart';
import 'unread_badge.dart';

class BookmarkRow extends StatelessWidget {
  const BookmarkRow({
    super.key,
    required this.bookmark,
    required this.appearance,
    this.subtitle,
    this.onTap,
    this.onLongPress,
  });

  final Bookmark bookmark;
  final Appearance appearance;
  final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final unread = bookmark.unread > 0;
    final style = TextStyle(fontSize: appearance.fontSize);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: RowFrame(
        appearance: appearance,
        child: Row(
          children: [
            UnreadBadge(count: bookmark.unread, fontSize: appearance.fontSize),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style.copyWith(
                      fontWeight: unread ? FontWeight.w600 : FontWeight.normal,
                      color: unread
                          ? appearance.bookmarkUnreadColor
                          : appearance.bookmarkReadColor,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      key: const Key('bookmark_subtitle'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: appearance.fontSize - 3,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            if (bookmark.replies > 0) ...[
              const SizedBox(width: 8),
              ReplyBadge(
                count: bookmark.replies,
                fontSize: appearance.fontSize,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

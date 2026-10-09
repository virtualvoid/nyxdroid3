// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/widgets/feed_scaffold.dart';
import '../../core/models/notice.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../discussion/link_actions.dart';
import '../discussion/ratings_dialog.dart';
import 'notice_tile.dart';
import 'notices_controller.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = ref.watch(appearanceProvider);

    return FeedScaffold<Notice>(
      provider: noticesControllerProvider,
      title: AppLocalizations.of(context).menuNotifications,
      refreshOnPush: (m) => m.isReply,
      showNotificationsBadge: false,
      itemBuilder: (context, notice) => NoticeTile(
        notice: notice,
        appearance: appearance,
        onTap: () => _open(context, notice),
        onLink: (url) => openExternal(context, url),
      ),
    );
  }

  void _open(BuildContext context, Notice notice) {
    if (notice.opensDiscussion) {
      openDiscussion(
        context,
        notice.discussionId!,
        postId: notice.writeupId! + 1,
      );
    } else if (notice.type == NoticeType.thumbs &&
        notice.discussionId != null &&
        notice.writeupId != null) {
      showRatingsDialog(
        context,
        discussionId: notice.discussionId!,
        writeupId: notice.writeupId!,
      );
    }
  }
}

// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/widgets/feed_scaffold.dart';
import '../../core/models/last_post.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../discussion/link_actions.dart';
import 'last_controller.dart';
import 'last_tile.dart';

class LastScreen extends ConsumerWidget {
  const LastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = ref.watch(appearanceProvider);

    return FeedScaffold<LastPost>(
      provider: lastControllerProvider,
      title: AppLocalizations.of(context).menuLast,
      itemBuilder: (context, post) => LastTile(
        post: post,
        appearance: appearance,
        onTap: () => openDiscussion(
          context,
          post.discussionId,
          postId: post.writeup.id + 1,
        ),
        onLink: (url) => openExternal(context, url),
      ),
    );
  }
}

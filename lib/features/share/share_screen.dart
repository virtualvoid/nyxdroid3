// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/widgets/common_widgets.dart';
import '../../app/widgets/empty_refresh_list.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../bookmarks/bookmark_list_item.dart';
import '../bookmarks/bookmark_row.dart';
import '../bookmarks/category_row.dart';
import 'exit_app.dart';
import 'pending_share_notifier.dart';
import 'share_controller.dart';
import 'share_outcome.dart';
import 'shared_content.dart';

class ShareScreen extends ConsumerStatefulWidget {
  const ShareScreen({super.key});

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  final _message = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(shareControllerProvider.notifier).load());
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    ref.read(pendingShareProvider.notifier).clear();
    await ref.read(exitAppProvider)();
    if (mounted) context.go(Routes.home);
  }

  Future<void> _pick(String name, int id, SharedContent content) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.reallyWannaShare,
      message: l10n.areYouSureYouWannaShareThis(name),
      yesLabel: l10n.yes,
      noLabel: l10n.no,
    );
    if (!mounted) return;
    if (!confirmed) return _finish();

    final outcome = await ref
        .read(shareControllerProvider.notifier)
        .send(id, _message.text, content);
    if (!mounted) return;
    switch (outcome) {
      case ShareOutcome.sent:
        await _finish();
      case ShareOutcome.unreadable:
        showSnack(context, l10n.fileDoesntExistsOrCantRead);
      case ShareOutcome.failed:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(shareControllerProvider);
    final content = ref.watch(pendingShareProvider);
    final appearance = ref.watch(appearanceProvider);

    listenForErrors(
      ref,
      context,
      shareControllerProvider.select((s) => s.error),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l10n.shareToDiscussion),
          bottom: loadingBar(state.loading || state.sending),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                key: const Key('share_message'),
                controller: _message,
                decoration: InputDecoration(hintText: l10n.additionalMessage),
              ),
            ),
            Expanded(
              child: state.items.isEmpty
                  ? EmptyRefreshList(
                      loading: state.loading,
                      error: state.error,
                      onRetry: ref.read(shareControllerProvider.notifier).load,
                    )
                  : ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, i) => switch (state.items[i]) {
                        CategoryItem(:final category) => CategoryRow(
                          category: category,
                          appearance: appearance,
                        ),
                        DiscussionItem(:final bookmark) => BookmarkRow(
                          bookmark: bookmark,
                          appearance: appearance,
                          onTap: content == null || state.sending
                              ? null
                              : () =>
                                    _pick(bookmark.name, bookmark.id, content),
                        ),
                        ReminderItem() => const SizedBox.shrink(),
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_drawer.dart';
import '../../app/app_resume_notifier.dart';
import '../../app/drawer_edge.dart';
import '../../app/router.dart';
import '../../app/widgets/action_item.dart';
import '../../app/widgets/common_widgets.dart';
import '../../app/widgets/empty_refresh_list.dart';
import '../../app/widgets/refresh_action.dart';
import '../../app/widgets/search_field.dart';
import '../../core/models/mail.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../discussion/content_html.dart';
import '../discussion/link_actions.dart';
import '../discussion/link_target.dart';
import '../push/push_service.dart';
import 'conversations_drawer.dart';
import 'mail_compose_args.dart';
import 'mail_controller.dart';
import 'mail_state.dart';
import 'mail_tile.dart';

enum MailAction { reply, copy, reminder, delete }

class MailScreen extends ConsumerStatefulWidget {
  const MailScreen({super.key, this.mailId});

  final int? mailId;

  @override
  ConsumerState<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends ConsumerState<MailScreen> {
  final _scaffold = GlobalKey<ScaffoldState>();
  final _scroll = ScrollController();
  final _search = TextEditingController();
  bool _searchOpen = false;

  MailController get _controller => ref.read(mailControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
    Future.microtask(() => _controller.loadInitial(mailId: widget.mailId));
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!_scroll.hasClients) return;
    final pos = _scroll.position;
    if (pos.maxScrollExtent - pos.pixels < 300) _controller.loadMore();
  }

  void _closeSearch() {
    setState(() => _searchOpen = false);
    _search.clear();
    _controller.refresh();
  }

  Future<void> _compose({Mail? replyTo, bool quote = false}) async {
    final sent = await context.push<bool>(
      Routes.mailCompose,
      extra: MailComposeArgs(replyTo: replyTo, quoteReply: quote),
    );
    if (sent == true && mounted) await _controller.refresh();
  }

  Future<void> _onLongPress(Mail mail) async {
    final l10n = AppLocalizations.of(context);
    final action = await showActionSheet<MailAction>(context, [
      ActionItem(MailAction.reply, Icons.reply, l10n.reply),
      ActionItem(MailAction.copy, Icons.copy, l10n.copy),
      ActionItem(
        MailAction.reminder,
        Icons.alarm,
        l10n.reminder,
        trailing: mail.isReminded ? const Icon(Icons.check) : null,
      ),
      ActionItem(MailAction.delete, Icons.delete_outline, l10n.delete),
    ]);
    if (action == null || !mounted) return;

    switch (action) {
      case MailAction.reply:
        await _compose(replyTo: mail, quote: true);
      case MailAction.copy:
        await Clipboard.setData(
          ClipboardData(text: stripHtmlTags(mail.content)),
        );
      case MailAction.reminder:
        await _controller.toggleReminder(mail.id);
      case MailAction.delete:
        await _controller.deleteMail(mail.id);
    }
  }

  Future<void> _onLink(String url) async {
    switch (classifyLink(url)) {
      case MailLink(:final mailId):
        await _controller.loadInitial(mailId: mailId);
      case DiscussionLink(:final discussionId, :final postId):
        openDiscussion(context, discussionId, postId: postId);
      case ImageLink(:final url):
        openImage(context, url);
      case ExternalLink(:final url):
        await openExternal(context, url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(mailControllerProvider);
    final appearance = ref.watch(appearanceProvider);

    listenForErrors(
      ref,
      context,
      mailControllerProvider.select((s) => s.error),
    );

    ref.listen(appResumeProvider, (_, _) {
      if (!_searchOpen && !state.filtered) _controller.refresh();
    });

    ref.listen(pushEventsProvider, (_, event) {
      if (event.value?.isNewMail ?? false) _controller.refresh();
    });

    ref.listen(mailControllerProvider.select((s) => s.mails.length), (_, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _maybeLoadMore();
      });
    });

    final now = DateTime.now();

    return Scaffold(
      key: _scaffold,
      drawer: const AppDrawer(),
      drawerEdgeDragWidth: drawerEdgeDragWidth(context),
      endDrawer: ConversationsDrawer(
        onSelected: (nick) {
          Navigator.of(context).pop();
          _controller.filterByNick(nick);
        },
      ),
      onEndDrawerChanged: (open) {
        if (open) _controller.loadConversations();
      },
      appBar: AppBar(
        title: _searchOpen
            ? SearchField(
                controller: _search,
                hint: l10n.search,
                onSubmitted: _controller.search,
              )
            : Text(l10n.menuMail),
        actions: [
          if (_searchOpen)
            IconButton(
              key: const Key('search_close'),
              icon: const Icon(Icons.close),
              onPressed: _closeSearch,
            )
          else ...[
            IconButton(
              key: const Key('compose_new'),
              tooltip: l10n.mailNew,
              icon: const Icon(Icons.add),
              onPressed: () => _compose(),
            ),
            RefreshAction(onPressed: _controller.refresh),
            IconButton(
              key: const Key('search_open'),
              tooltip: l10n.search,
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _searchOpen = true),
            ),
            IconButton(
              key: const Key('conversations_open'),
              icon: const Icon(Icons.people_outline),
              onPressed: () => _scaffold.currentState?.openEndDrawer(),
            ),
          ],
        ],
        bottom: loadingBar(state.loading || state.loadingMore),
      ),
      body: RefreshIndicator(
        onRefresh: _controller.refresh,
        child: state.mails.isEmpty
            ? EmptyRefreshList(
                loading: state.loading,
                error: state.error,
                onRetry: _controller.refresh,
              )
            : ListView.builder(
                controller: _scroll,
                itemCount: state.mails.length,
                itemBuilder: (context, i) {
                  final mail = state.mails[i];
                  return MailTile(
                    key: ValueKey(mail.id),
                    mail: mail,
                    appearance: appearance,
                    now: now,
                    onTap: () => _compose(replyTo: mail),
                    onLongPress: () => _onLongPress(mail),
                    onLink: _onLink,
                    onImage: (url) => openImage(context, url),
                  );
                },
              ),
      ),
    );
  }
}

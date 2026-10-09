// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../app/router.dart';
import '../../app/widgets/common_widgets.dart';
import '../../app/widgets/empty_refresh_list.dart';
import '../../app/widgets/mail_badge_action.dart';
import '../../app/widgets/notifications_badge_action.dart';
import '../../app/widgets/refresh_action.dart';
import '../../core/models/writeup.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../gallery/gallery_image.dart';
import 'compose_args.dart';
import 'compose_result.dart';
import 'content_html.dart';
import 'discussion_controller.dart';
import 'discussion_repository.dart';
import 'discussion_state.dart';
import 'discussion_tabs.dart';
import 'link_actions.dart';
import 'link_target.dart';
import 'post_actions.dart';
import 'ratings_dialog.dart';
import 'writeup_tile.dart';

class DiscussionScreen extends ConsumerStatefulWidget {
  const DiscussionScreen({
    super.key,
    required this.discussionId,
    this.title,
    this.wuId,
  });

  final int discussionId;
  final String? title;
  final int? wuId;

  @override
  ConsumerState<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends ConsumerState<DiscussionScreen>
    with SingleTickerProviderStateMixin {
  static const _tabDiscussion = 0;
  static const _tabHeader = 1;
  static const _tabBoard = 2;

  final _scroll = ItemScrollController();
  final _positions = ItemPositionsListener.create();
  final _search = TextEditingController();
  late final TabController _tabs;
  final Set<int> _visitedTabs = {_tabDiscussion};
  int _handledScrollNonce = -1;
  int _tappedTab = _tabDiscussion;
  final List<int> _previousPositions = [];
  bool _searchOpen = false;

  final Map<int, Writeup> _selected = {};
  bool _selecting = false;

  DiscussionArgs get _args => (id: widget.discussionId, wuId: widget.wuId);

  DiscussionController get _controller =>
      ref.read(discussionControllerProvider(_args).notifier);

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this)..addListener(_onTabChanged);
    _positions.itemPositions.addListener(_maybeLoadMore);
    Future.microtask(_controller.loadInitial);
  }

  @override
  void dispose() {
    _positions.itemPositions.removeListener(_maybeLoadMore);
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_visitedTabs.add(_tabs.index)) setState(() {});
    setState(() {});
  }

  void _maybeLoadMore() {
    final state = ref.read(discussionControllerProvider(_args));
    final visible = _positions.itemPositions.value;
    if (visible.isEmpty || state.writeups.isEmpty) return;
    final last = visible.map((p) => p.index).reduce((a, b) => a > b ? a : b);
    if (last >= state.writeups.length - 2) _controller.loadMore();
  }

  void _rememberPosition() {
    if (!ref.read(appPrefsProvider).backpressReturnsWriteup) return;
    final visible = _positions.itemPositions.value;
    if (visible.isEmpty) return;
    setState(
      () => _previousPositions.add(
        visible.map((p) => p.index).reduce((a, b) => a < b ? a : b),
      ),
    );
  }

  void _forgetPosition() {
    if (_previousPositions.isNotEmpty) setState(_previousPositions.removeLast);
  }

  void _refresh() {
    switch (_tabs.index) {
      case _tabBoard:
        ref.invalidate(discussionBoardProvider(widget.discussionId));
      case _tabHeader:
        ref.invalidate(discussionHeaderProvider(widget.discussionId));
      default:
        _controller.refresh();
    }
  }

  void _closeSearch() {
    setState(() => _searchOpen = false);
    _search.clear();
    _controller.refresh();
  }

  Future<void> _onLink(String url, {int? writeupId}) async {
    switch (classifyLink(url)) {
      case DiscussionLink(:final discussionId, :final postId):
        if (discussionId == widget.discussionId && postId != null) {
          _tabs.index = _tappedTab = _tabDiscussion;
          _rememberPosition();
          final found = await _controller.jumpTo(postId);
          if (!found && mounted) {
            _forgetPosition();
            showSnack(context, 'Uhm...');
          }
        } else {
          openDiscussion(context, discussionId, postId: postId);
        }
      case MailLink(:final mailId):
        openMail(context, mailId: mailId);
      case ImageLink(:final url):
        await _openGallery(writeupId, url);
      case ExternalLink(:final url):
        await openExternal(context, url);
    }
  }

  Future<void> _openGallery(int? writeupId, String? url) async {
    final selection = buildGallery(
      ref.read(discussionControllerProvider(_args)).writeups,
      startWriteupId: writeupId,
      startUrl: url,
    );
    if (selection == null) {
      showSnack(
        context,
        AppLocalizations.of(context).discussionDoesntContainImages,
      );
      return;
    }
    final target = await openGallery(
      context,
      selection.images,
      startIndex: selection.startIndex,
    );
    if (target != null && target != 0 && mounted) {
      _tabs.index = _tappedTab = _tabDiscussion;
      await _controller.jumpTo(target);
    }
  }

  Future<void> _vote(Writeup wu, VotingType type) async {
    final result = await _controller.vote(wu.id, type);
    if (result != VotingResult.needsConfirmation || !mounted) return;

    final l10n = AppLocalizations.of(context);
    final yes = await showConfirmDialog(
      context,
      title: l10n.anonymousVoteWarningTitle,
      message: l10n.anonymousVoteWarning,
      yesLabel: l10n.positiveButton,
      noLabel: l10n.negativeButton,
    );
    if (yes) await _controller.confirmNegativeVisible(wu.id);
  }

  Future<void> _compose(List<Writeup> replying) async {
    final name = ref.read(discussionControllerProvider(_args)).name;
    final result = await context.push<ComposeResult>(
      Routes.compose,
      extra: ComposeArgs(
        discussionId: widget.discussionId,
        discussionName: name.isNotEmpty
            ? name
            : (widget.title ?? '#${widget.discussionId}'),
        replying: replying,
      ),
    );
    if (!mounted) return;

    switch (result) {
      case ComposeSent():
        if (ref.read(appPrefsProvider).refreshAfterWriteupSend) {
          await _controller.refresh();
        }
      case ComposeVote(:final writeupId, :final type):
        final wu = ref
            .read(discussionControllerProvider(_args))
            .writeups
            .where((w) => w.id == writeupId)
            .firstOrNull;
        if (wu != null) await _vote(wu, type);
      case null:
        break;
    }
  }

  Future<void> _onLongPress(Writeup wu) async {
    final action = await showPostActions(context, wu);
    if (action == null || !mounted) return;
    await _runAction(action, wu);
  }

  Future<void> _runAction(PostAction action, Writeup wu) async {
    final l10n = AppLocalizations.of(context);
    switch (action) {
      case PostAction.reply:
        await _compose([wu]);
      case PostAction.sendMail:
        context.push(
          Uri(
            path: Routes.mailCompose,
            queryParameters: {'nick': wu.nick},
          ).toString(),
        );
      case PostAction.viewReplies:
        final count = await _controller.showReplies(wu.id);
        if (count == 0 && mounted) {
          showSnack(context, l10n.noResponsesForThisWriteup);
        }
      case PostAction.viewRating:
        await showRatingsDialog(
          context,
          discussionId: widget.discussionId,
          writeupId: wu.id,
        );
      case PostAction.copy:
        await Clipboard.setData(ClipboardData(text: stripHtmlTags(wu.content)));
      case PostAction.gallery:
        await _openGallery(wu.id, null);
      case PostAction.reminder:
        await _controller.toggleReminder(wu.id);
      case PostAction.delete:
        await _controller.deleteWriteup(wu.id);
      case PostAction.copyLink:
        await Clipboard.setData(
          ClipboardData(
            text:
                'https://nyx.cz/discussion/${widget.discussionId}/id/${wu.id}',
          ),
        );
    }
  }

  void _startSelecting() => setState(() {
    _selecting = true;
    _selected.clear();
  });

  void _stopSelecting() => setState(() {
    _selecting = false;
    _selected.clear();
  });

  void _select(Writeup wu, bool on) => setState(() {
    if (on) {
      _selected[wu.id] = wu;
    } else {
      _selected.remove(wu.id);
    }
  });

  Future<void> _replyToSelected() async {
    final list = _selected.values.toList();
    _stopSelecting();
    await _compose(list);
  }

  void _openGalleryGrid() {
    if (ref.read(discussionControllerProvider(_args)).writeups.isEmpty) return;
    context.push(
      Uri(
        path: Routes.galleryGrid,
        queryParameters: {'id': '${widget.discussionId}'},
      ).toString(),
    );
  }

  Future<void> _bookOrUnbook() async {
    final state = ref.read(discussionControllerProvider(_args));
    if (state.booked) {
      await _controller.unbook();
      return;
    }

    final l10n = AppLocalizations.of(context);
    try {
      final categories = await ref
          .read(bookmarksRepositoryProvider)
          .getCategories();
      if (!mounted) return;
      if (categories.isEmpty) {
        showSnack(context, l10n.addDiscussionToCategoryNoCategories);
        return;
      }
      final selected = await showDialog<int>(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: Text(l10n.addDiscussionToCategoryTitle),
          children: [
            for (final c in categories)
              SimpleDialogOption(
                key: Key('category_${c.id}'),
                onPressed: () => Navigator.pop(ctx, c.id),
                child: Text(c.name),
              ),
          ],
        ),
      );
      if (selected != null) await _controller.book(selected);
    } catch (e) {
      if (mounted) showSnack(context, '$e');
    }
  }

  PreferredSizeWidget _appBar(
    AppLocalizations l10n,
    DiscussionState state,
    String title,
  ) {
    if (_selecting) {
      return AppBar(
        leading: IconButton(
          key: const Key('select_close'),
          icon: const Icon(Icons.close),
          onPressed: _stopSelecting,
        ),
        title: Text(l10n.replyToMoreWriteups),
        actions: [
          IconButton(
            key: const Key('select_reply'),
            tooltip: l10n.reply,
            icon: const Icon(Icons.reply),
            onPressed: _replyToSelected,
          ),
        ],
      );
    }

    final loading = state.loading || state.loadingMore;

    return AppBar(
      title: _searchOpen
          ? TextField(
              controller: _search,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.search,
                border: InputBorder.none,
              ),
              onSubmitted: _controller.search,
            )
          : Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        if (_searchOpen)
          IconButton(
            key: const Key('search_close'),
            icon: const Icon(Icons.close),
            onPressed: _closeSearch,
          )
        else ...[
          NotificationsBadgeAction(
            unread: state.context?.user.unreadNotifications ?? 0,
            onPressed: () => openNotifications(context),
          ),
          MailBadgeAction(
            unreadMail: state.context?.user.unreadMail ?? 0,
            onPressed: () => openMail(context),
          ),
          IconButton(
            key: const Key('compose_new'),
            tooltip: l10n.newWriteup,
            icon: const Icon(Icons.add),
            onPressed: () => _compose(const []),
          ),
          IconButton(
            key: const Key('search_open'),
            tooltip: l10n.search,
            icon: const Icon(Icons.search),
            onPressed: () => setState(() => _searchOpen = true),
          ),
          RefreshAction(onPressed: _refresh),
          PopupMenuButton<String>(
            key: const Key('discussion_menu'),
            onSelected: (v) {
              switch (v) {
                case 'gallery':
                  _openGalleryGrid();
                case 'reply_more':
                  _startSelecting();
                case 'book':
                  _bookOrUnbook();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                key: const Key('menu_gallery'),
                value: 'gallery',
                child: Text(l10n.viewAsGallery),
              ),
              PopupMenuItem(
                key: const Key('menu_reply_more'),
                value: 'reply_more',
                child: Text(l10n.replyToMoreWriteups),
              ),
              PopupMenuItem(
                key: const Key('menu_book'),
                value: 'book',
                child: Text(
                  state.booked ? l10n.bookTitleUnbook : l10n.bookTitleBook,
                ),
              ),
            ],
          ),
        ],
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight + 2),
        child: Column(
          children: [
            TabBar(
              controller: _tabs,
              onTap: (i) {
                final reselected = i == _tappedTab;
                _tappedTab = i;
                if (reselected && i == _tabBoard) _refresh();
              },
              tabs: [
                Tab(key: const Key('tab_discussion'), text: l10n.tabDiscussion),
                Tab(key: const Key('tab_header'), text: l10n.tabHeader),
                Tab(key: const Key('tab_board'), text: l10n.tabBoard),
              ],
            ),
            SizedBox(
              height: 2,
              child: loading
                  ? const LinearProgressIndicator(minHeight: 2)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _discussionList(DiscussionState state) {
    final appearance = ref.watch(appearanceProvider);
    final now = DateTime.now();

    return RefreshIndicator(
      onRefresh: _controller.refresh,
      child: state.writeups.isEmpty
          ? EmptyRefreshList(
              loading: state.loading,
              error: state.error,
              onRetry: _refresh,
            )
          : ScrollablePositionedList.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemScrollController: _scroll,
              itemPositionsListener: _positions,
              itemCount: state.writeups.length,
              itemBuilder: (context, i) {
                final wu = state.writeups[i];
                return WriteupTile(
                  key: ValueKey(wu.id),
                  writeup: wu,
                  appearance: appearance,
                  now: now,
                  onVote: (type) => _vote(wu, type),
                  onPollVote: (key) => _controller.pollVote(wu.id, key),
                  onLink: (url) => _onLink(url, writeupId: wu.id),
                  onImage: (url) => _openGallery(wu.id, url),
                  onTap: _selecting ? null : () => _compose([wu]),
                  onLongPress: _selecting ? null : () => _onLongPress(wu),
                  selectionVisible: _selecting,
                  selected: _selected.containsKey(wu.id),
                  onSelectedChanged: (on) => _select(wu, on),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(discussionControllerProvider(_args));

    listenForErrors(
      ref,
      context,
      discussionControllerProvider(_args).select((s) => s.error),
    );

    ref.listen(discussionControllerProvider(_args).select((s) => s.scroll), (
      _,
      req,
    ) {
      if (req == null || req.nonce == _handledScrollNonce) return;
      _handledScrollNonce = req.nonce;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final count = ref
            .read(discussionControllerProvider(_args))
            .writeups
            .length;
        if (_scroll.isAttached && req.index < count) {
          _scroll.jumpTo(index: req.index);
        }
      });
    });

    final title = state.name.isNotEmpty
        ? state.name
        : (widget.title ?? '#${widget.discussionId}');
    final id = widget.discussionId;

    final returnsToPosition =
        ref.watch(appPrefsProvider).backpressReturnsWriteup &&
        _previousPositions.isNotEmpty;

    return PopScope(
      canPop: !_selecting && !returnsToPosition,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_selecting) {
          _stopSelecting();
        } else if (returnsToPosition) {
          final index = _previousPositions.last;
          _forgetPosition();
          if (_scroll.isAttached) _scroll.jumpTo(index: index);
        }
      },
      child: Scaffold(
        appBar: _appBar(l10n, state, title),
        body: IndexedStack(
          index: _tabs.index,
          children: [
            _discussionList(state),
            if (_visitedTabs.contains(_tabHeader))
              HtmlTab(
                provider: discussionHeaderProvider(id),
                emptyText: (l) => l.noData,
                onLink: _onLink,
                onImage: (url) => _onLink(url),
              )
            else
              const SizedBox.shrink(),
            if (_visitedTabs.contains(_tabBoard))
              HtmlTab(
                provider: discussionBoardProvider(id),
                emptyText: (l) => l.boardEmpty,
                onLink: _onLink,
                onImage: (url) => _onLink(url),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

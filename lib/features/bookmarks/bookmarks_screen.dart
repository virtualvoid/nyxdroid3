// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_drawer.dart';
import '../../app/app_resume_notifier.dart';
import '../../app/drawer_edge.dart';
import '../../app/appearance.dart';
import '../../app/router.dart';
import '../../app/widgets/action_item.dart';
import '../../app/widgets/common_widgets.dart';
import '../../app/widgets/empty_refresh_list.dart';
import '../../app/widgets/mail_badge_action.dart';
import '../../app/widgets/notifications_badge_action.dart';
import '../../app/widgets/refresh_action.dart';
import '../../app/widgets/search_field.dart';
import '../../core/models/bookmark.dart';
import '../../core/relative_time.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import 'bookmark_list_item.dart';
import 'bookmark_row.dart';
import 'bookmarks_controller.dart';
import 'bookmarks_state.dart';
import 'category_row.dart';
import 'history_action.dart';
import 'history_day_header.dart';
import 'history_grouping.dart';
import 'history_swipe_background.dart';
import 'reminder_row.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key, required this.mode});

  final BookmarksMode mode;

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  final _searchController = TextEditingController();
  bool _searchOpen = false;
  bool _loadedOnce = false;

  BookmarksMode get _mode => widget.mode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadedOnce) {
      _loadedOnce = true;

      Future.microtask(_refresh);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  BookmarksController get _controller =>
      ref.read(bookmarksControllerProvider(_mode).notifier);

  Future<void> _refresh() => _controller.refresh(
    remindersTitle: AppLocalizations.of(context).reminders,
  );

  void _closeSearch() {
    setState(() => _searchOpen = false);
    _searchController.clear();
    _refresh();
  }

  void _open(Bookmark bookmark, {int? discussionId, int? postId}) {
    _controller.markRead(bookmark.id);
    context.push(
      Uri(
        path: '/discussion/${discussionId ?? bookmark.id}',
        queryParameters: {
          'title': bookmark.name,
          if (postId != null) 'wuId': '$postId',
        },
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(bookmarksControllerProvider(_mode));
    final appearance = ref.watch(appearanceProvider);
    final isHistory = _mode == BookmarksMode.history;
    final unreadMail = state.context?.user.unreadMail ?? 0;

    listenForErrors(
      ref,
      context,
      bookmarksControllerProvider(_mode).select((s) => s.error),
    );

    ref.listen(appResumeProvider, (_, _) {
      if (!_searchOpen && !state.searching) _refresh();
    });

    final filterTitle = state.showRead
        ? l10n.historyShowUnread
        : (isHistory ? l10n.historyShowAll : l10n.bookmarksShowAll);

    final items = state.visible;
    final expandedCategories = {
      for (final i in items)
        if (i is DiscussionItem && i.bookmark.categoryId != null)
          i.bookmark.categoryId!,
    };

    return Scaffold(
      drawer: const AppDrawer(),
      drawerEdgeDragWidth: drawerEdgeDragWidth(
        context,
        fraction: isHistory ? drawerNarrowFraction : drawerWideFraction,
      ),
      appBar: AppBar(
        title: _searchOpen
            ? SearchField(
                controller: _searchController,
                hint: l10n.bookmarksSearch,
                onSubmitted: _controller.search,
              )
            : Text(isHistory ? l10n.menuHistory : l10n.menuBookmarks),
        actions: [
          if (!_searchOpen)
            NotificationsBadgeAction(
              unread: state.context?.user.unreadNotifications ?? 0,
              onPressed: () => context.go(Routes.notifications),
            ),
          MailBadgeAction(
            unreadMail: unreadMail,
            onPressed: () => context.go(Routes.mail),
          ),
          if (_searchOpen)
            IconButton(
              key: const Key('search_close'),
              icon: const Icon(Icons.close),
              onPressed: _closeSearch,
            )
          else
            IconButton(
              key: const Key('search_open'),
              tooltip: l10n.bookmarksSearch,
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _searchOpen = true),
            ),
          if (!_searchOpen) ...[
            IconButton(
              key: const Key('filter_toggle'),
              tooltip: filterTitle,
              icon: Icon(
                state.showRead ? Icons.filter_list_off : Icons.filter_list,
              ),
              onPressed: () =>
                  _controller.toggleShowRead(remindersTitle: l10n.reminders),
            ),
            RefreshAction(onPressed: _refresh),
            if (isHistory)
              PopupMenuButton<String>(
                key: const Key('history_menu'),
                onSelected: (_) => _controller.markAllHistoryRead(),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    key: const Key('history_mark_all'),
                    value: 'all',
                    enabled: state.all.any(
                      (i) => i is DiscussionItem && i.bookmark.unread > 0,
                    ),
                    child: Text(l10n.historyMarkAllRead),
                  ),
                ],
              ),
          ],
        ],
        bottom: loadingBar(state.loading),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: items.isEmpty
            ? EmptyRefreshList(
                loading: state.loading,
                error: state.error,
                onRetry: _refresh,
              )
            : isHistory && !state.searching
            ? _historyList(
                items,
                appearance,
                hasMore: state.hasMore,
                loading: state.loading,
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) => _buildItem(
                  items[i],
                  appearance,
                  expandedCategories,
                  state.categoriesWithDiscussions,
                ),
              ),
      ),
    );
  }

  Widget _historyList(
    List<BookmarkListItem> items,
    Appearance appearance, {
    required bool hasMore,
    required bool loading,
  }) {
    final now = DateTime.now();
    final entries = <Object>[];
    if (appearance.historyTimes) {
      for (final section in groupHistoryByDay(
        items.whereType<DiscussionItem>().toList(),
      )) {
        entries.add((day: section.day));
        entries.addAll(section.items);
      }
    } else {
      entries.addAll(items.whereType<DiscussionItem>());
    }
    if (hasMore) entries.add((footer: true));

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, i) => switch (entries[i]) {
        (day: final DateTime? day) => HistoryDayHeader(
          day: day,
          now: now,
          appearance: appearance,
        ),
        DiscussionItem(:final bookmark) => _historyRow(
          bookmark,
          appearance,
          now,
        ),
        (footer: true) => Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: FilledButton.tonal(
              key: const Key('history_load_more'),
              onPressed: loading ? null : _controller.loadMoreHistory,
              child: Text(AppLocalizations.of(context).historyLoadMore),
            ),
          ),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _historyRow(Bookmark bookmark, Appearance appearance, DateTime now) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final unread = bookmark.unread > 0;

    return Dismissible(
      key: ValueKey('history_${bookmark.id}'),
      direction: unread
          ? DismissDirection.horizontal
          : DismissDirection.endToStart,
      background: HistorySwipeBackground(
        icon: Icons.done_all,
        alignment: Alignment.centerLeft,
        color: scheme.primaryContainer,
        iconColor: scheme.onPrimaryContainer,
      ),
      secondaryBackground: HistorySwipeBackground(
        icon: Icons.delete_outline,
        alignment: Alignment.centerRight,
        color: scheme.errorContainer,
        iconColor: scheme.onErrorContainer,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _controller.markHistoryRead([bookmark.id]);
          return false;
        }
        return true;
      },
      onDismissed: (_) => _removeFromHistory(bookmark),
      child: BookmarkRow(
        bookmark: bookmark,
        appearance: appearance,
        subtitle: bookmark.lastVisitedAt == null || !appearance.historyTimes
            ? null
            : relativeTime(l10n, bookmark.lastVisitedAt!, now),
        onTap: () => _open(bookmark),
        onLongPress: () => _historyActions(bookmark),
      ),
    );
  }

  void _removeFromHistory(Bookmark bookmark) {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    _controller.removeFromHistory([bookmark.id]);
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          key: const Key('history_removed_snack'),
          persist: false,
          duration: historyUndoDuration,
          content: Text(
            l10n.historyRemovedSnack(bookmark.name),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: _controller.undoHistoryRemoval,
          ),
        ),
      );
  }

  Future<void> _historyActions(Bookmark bookmark) async {
    final l10n = AppLocalizations.of(context);
    final action = await showActionSheet<HistoryAction>(context, [
      if (bookmark.unread > 0)
        ActionItem(
          HistoryAction.markRead,
          Icons.done_all,
          l10n.historyMarkRead,
        ),
      ActionItem(
        HistoryAction.remove,
        Icons.delete_outline,
        l10n.historyRemove,
      ),
    ]);
    switch (action) {
      case HistoryAction.markRead:
        await _controller.markHistoryRead([bookmark.id]);
      case HistoryAction.remove:
        _removeFromHistory(bookmark);
      case null:
        break;
    }
  }

  Widget _buildItem(
    BookmarkListItem item,
    Appearance appearance,
    Set<int> expandedCategories,
    Set<int> withItems,
  ) => switch (item) {
    CategoryItem(:final category) => CategoryRow(
      category: category,
      appearance: appearance,
      expanded: withItems.contains(category.id)
          ? expandedCategories.contains(category.id)
          : null,
      onTap: () => _controller.toggleCategory(category.id),
    ),
    DiscussionItem(:final bookmark) => BookmarkRow(
      bookmark: bookmark,
      appearance: appearance,
      onTap: () => _open(bookmark),
    ),
    ReminderItem(:final reminder, :final isSingle) => ReminderRow(
      reminder: reminder,
      isSingle: isSingle,
      appearance: appearance,
      onTap: () => _open(
        Bookmark(id: reminder.discussionId, name: reminder.name),
        postId: reminder.id,
      ),
    ),
  };
}

// author: juraj.suchan@gmail.com

import '../../core/api/api_client.dart';
import '../../core/json_utils.dart';
import '../../core/models/api_context.dart';
import '../../core/models/bookmark.dart';
import '../../core/models/bookmark_category.dart';
import '../../core/models/bookmark_reminder.dart';
import 'bookmark_list_item.dart';
import 'bookmarks_result.dart';

class BookmarksRepository {
  BookmarksRepository(this._api);

  final ApiClient _api;

  Future<BookmarksResult> getAll({
    required bool includeRead,
    required bool remindersEnabled,
    required String remindersTitle,
  }) async {
    final root = asMap(await _api.get('/bookmarks/all')) ?? const {};
    final items = <BookmarkListItem>[];

    final reminderCount = asInt(root['reminder_count']) ?? 0;
    if (remindersEnabled && reminderCount > 0) {
      items.addAll(await _reminders(remindersTitle));
    }

    for (final group in asMapList(root['bookmarks'])) {
      final catJson = asMap(group['category']);
      if (catJson == null) continue;
      final category = BookmarkCategory.fromJson(catJson);
      items.add(CategoryItem(category));
      for (final b in asMapList(group['bookmarks'])) {
        final bookmark = Bookmark.fromJson(b, categoryId: category.id);
        if (!includeRead && bookmark.unread <= 0) continue;
        items.add(DiscussionItem(bookmark));
      }
    }

    return BookmarksResult(items, ApiContext.fromRoot(root));
  }

  Future<List<BookmarkCategory>> getCategories() async {
    final root = asMap(await _api.get('/bookmarks/all')) ?? const {};
    return [
      for (final group in asMapList(root['bookmarks']))
        if (asMap(group['category']) case final c?)
          BookmarkCategory.fromJson(c),
    ];
  }

  Future<BookmarksResult> getHistory({
    required bool includeRead,
    bool moreResults = false,
    bool? showBooked,
  }) async {
    final root =
        asMap(
          await _api.get(
            '/bookmarks/history',
            query: {
              'show_read': includeRead,
              if (moreResults) 'more_results': true,
              'show_booked': ?showBooked,
            },
          ),
        ) ??
        const {};
    final items = <BookmarkListItem>[];
    for (final d in asMapList(root['discussions'])) {
      final bookmark = Bookmark.fromJson(d);
      if (!includeRead && bookmark.unread == 0) continue;
      items.add(DiscussionItem(bookmark));
    }
    return BookmarksResult(
      items,
      ApiContext.fromRoot(root),
      hasMore: asBool(root['show_load_more']),
    );
  }

  Future<void> markHistoryRead(List<int> discussionIds) => _api.formList(
    '/bookmarks/history/mark_as_read',
    'discussion_ids',
    discussionIds,
  );

  Future<void> removeFromHistory(List<int> discussionIds) => _api.formList(
    '/bookmarks/history/remove_from_history',
    'discussion_ids',
    discussionIds,
  );

  Future<BookmarksResult> search(String term, {int limit = 30}) async {
    final root =
        asMap(
          await _api.get(
            '/search/unified',
            query: {'search': term, 'limit': limit},
          ),
        ) ??
        const {};
    final rows = asMapList(
      asMap(root['discussion'])?['discussions'] ?? root['discussions'],
    );

    final items = <BookmarkListItem>[];
    for (final row in rows) {
      final type = asString(row['discussion_type']);
      if (type == null || type.toLowerCase() != 'discussion') continue;
      items.add(
        DiscussionItem(
          Bookmark(
            id: asInt(row['id']) ?? 0,
            name: asString(row['discussion_name']) ?? '',
          ),
        ),
      );
    }
    return BookmarksResult(items, ApiContext.fromRoot(root));
  }

  Future<List<BookmarkListItem>> _reminders(String title) async {
    final root = asMap(await _api.get('/bookmarks/reminders')) ?? const {};
    final reminders = asMapList(root['posts']).map(BookmarkReminder.fromJson);

    final grouped = <int, List<BookmarkReminder>>{};
    for (final r in reminders) {
      grouped.putIfAbsent(r.discussionId, () => []).add(r);
    }
    if (grouped.isEmpty) return const [];

    final multi = <BookmarkListItem>[];
    final singles = <BookmarkListItem>[
      CategoryItem(
        BookmarkCategory(id: BookmarkCategory.remindersId, name: title),
      ),
    ];
    for (final list in grouped.values) {
      if (list.length == 1) {
        singles.add(ReminderItem(list.first, isSingle: true));
      } else {
        multi.add(
          CategoryItem(
            BookmarkCategory(id: -list.first.id, name: list.first.name),
          ),
        );
        multi.addAll(list.map(ReminderItem.new));
      }
    }
    return [...multi, ...singles];
  }
}

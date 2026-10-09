// author: juraj.suchan@gmail.com

import '../../core/models/bookmark.dart';
import '../../core/models/bookmark_category.dart';
import '../../core/models/bookmark_reminder.dart';

part 'category_item.dart';
part 'discussion_item.dart';
part 'reminder_item.dart';

sealed class BookmarkListItem {
  const BookmarkListItem();
}

// author: juraj.suchan@gmail.com

import '../../core/models/api_context.dart';
import 'bookmark_list_item.dart';

class BookmarksResult {
  const BookmarksResult(this.items, this.context, {this.hasMore = false});
  final List<BookmarkListItem> items;
  final ApiContext? context;
  final bool hasMore;
}

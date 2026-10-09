// author: juraj.suchan@gmail.com

import 'bookmark.dart';
import 'bookmark_category.dart';

class BookmarkGroup {
  const BookmarkGroup({required this.category, required this.bookmarks});

  final BookmarkCategory category;
  final List<Bookmark> bookmarks;
}

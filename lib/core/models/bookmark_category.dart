// author: juraj.suchan@gmail.com

import '../json_utils.dart';

class BookmarkCategory {
  const BookmarkCategory({required this.id, required this.name});

  static const int remindersId = -1000;

  final int id;
  final String name;

  factory BookmarkCategory.fromJson(Map<String, dynamic> j) => BookmarkCategory(
    id: asInt(j['id']) ?? 0,
    name: asString(j['category_name']) ?? '',
  );
}

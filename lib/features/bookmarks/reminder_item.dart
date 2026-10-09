// author: juraj.suchan@gmail.com

part of 'bookmark_list_item.dart';

class ReminderItem extends BookmarkListItem {
  const ReminderItem(this.reminder, {this.isSingle = false});
  final BookmarkReminder reminder;

  final bool isSingle;
}

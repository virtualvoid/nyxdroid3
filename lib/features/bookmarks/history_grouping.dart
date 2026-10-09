// author: juraj.suchan@gmail.com

import 'bookmark_list_item.dart';

typedef HistorySection = ({DateTime? day, List<DiscussionItem> items});

DateTime _day(DateTime t) => DateTime(t.year, t.month, t.day);

DateTime? historyDay(DateTime? time) =>
    time == null ? null : _day(time.toLocal());

List<HistorySection> groupHistoryByDay(List<DiscussionItem> items) {
  final sections = <HistorySection>[];
  for (final item in items) {
    final day = historyDay(item.bookmark.lastVisitedAt);
    if (sections.isNotEmpty && sections.last.day == day) {
      sections.last.items.add(item);
    } else {
      sections.add((day: day, items: [item]));
    }
  }
  return sections;
}

// author: juraj.suchan@gmail.com

import 'api_context.dart';
import 'writeup.dart';

class DiscussionPage {
  const DiscussionPage({
    required this.id,
    required this.name,
    this.booked = false,
    this.canWrite = false,
    this.canDelete = false,
    this.writeups = const [],
    this.context,
  });

  final int id;
  final String name;
  final bool booked;
  final bool canWrite;
  final bool canDelete;
  final List<Writeup> writeups;
  final ApiContext? context;
}

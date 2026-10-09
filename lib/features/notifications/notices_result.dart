// author: juraj.suchan@gmail.com

import '../../core/models/api_context.dart';
import '../../core/models/notice.dart';

class NoticesResult {
  const NoticesResult(this.notices, this.context);

  final List<Notice> notices;
  final ApiContext? context;
}

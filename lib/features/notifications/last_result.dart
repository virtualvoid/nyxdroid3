// author: juraj.suchan@gmail.com

import '../../core/models/api_context.dart';
import '../../core/models/last_post.dart';

class LastResult {
  const LastResult(this.posts, this.context);

  final List<LastPost> posts;
  final ApiContext? context;
}

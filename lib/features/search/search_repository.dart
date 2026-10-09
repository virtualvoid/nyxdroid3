// author: juraj.suchan@gmail.com

import '../../core/api/api_client.dart';
import '../../core/json_utils.dart';
import '../../core/models/api_context.dart';
import '../../core/models/last_post.dart';
import 'search_page.dart';

class SearchRepository {
  SearchRepository(this._api, {required this.nick});

  final ApiClient _api;
  final String? Function() nick;

  Future<SearchPage> posts({
    String? user,
    String? text,
    int? olderThanId,
  }) async {
    final root =
        asMap(
          await _api.get(
            '/search-v2',
            query: {
              if (user != null && user.isNotEmpty) 'user': user,
              if (text != null && text.isNotEmpty) 'text': text,
              if (olderThanId != null) ...{
                'order': 'older_than',
                'from_id': olderThanId,
              },
            },
          ),
        ) ??
        const {};
    final me = nick();
    return SearchPage([
      for (final post in asMapList(root['posts']))
        ?LastPost.fromJson(post, myNick: me),
    ], ApiContext.fromRoot(root));
  }
}

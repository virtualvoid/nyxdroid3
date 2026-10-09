// author: juraj.suchan@gmail.com

import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/json_utils.dart';
import '../../core/models/api_context.dart';
import '../../core/models/discussion_page.dart';
import '../../core/models/writeup.dart';
import 'voting_info.dart';
import 'voting_response.dart';

class DiscussionRepository {
  DiscussionRepository(this._api, {required this.nick});

  final ApiClient _api;

  final String? Function() nick;

  Future<DiscussionPage> getWriteups(
    int discussionId, {
    WriteupDirection direction = WriteupDirection.newest,
    int? lastId,
    String? filterUser,
    String? filterText,
  }) async {
    final query = <String, dynamic>{};
    if (direction == WriteupDirection.older && lastId != null) {
      query['order'] = 'older_than';
      query['from_id'] = lastId + 1;
    }
    if (direction == WriteupDirection.newer && lastId != null) {
      query['order'] = 'newer_than';
      query['from_id'] = lastId - 1;
    }
    if (filterUser != null && filterUser.isNotEmpty) query['user'] = filterUser;
    if (filterText != null && filterText.isNotEmpty) query['text'] = filterText;

    final root =
        asMap(
          await _api.get(
            '/discussion/$discussionId',
            query: query.isEmpty ? null : query,
          ),
        ) ??
        const {};

    final common = asMap(root['discussion_common']);
    final discussion = asMap(common?['discussion']);

    final me = nick();
    final writeups = <Writeup>[];
    for (final post in asMapList(root['posts'])) {
      final wu = Writeup.fromJson(post, myNick: me);
      if (wu == null) continue;
      writeups.add(wu);
    }

    return DiscussionPage(
      id: asInt(discussion?['id']) ?? discussionId,
      name: asString(discussion?['name_static']) ?? '',
      booked: asBool(asMap(common?['bookmark'])?['bookmark']),
      canWrite: asBool(discussion?['ar_write']),
      canDelete: asBool(discussion?['ar_delete']),
      writeups: writeups,
      context: ApiContext.fromRoot(root),
    );
  }

  Future<VotingResponse> giveRating(
    int discussionId,
    int writeupId,
    VotingType type,
  ) async {
    try {
      final root =
          asMap(
            await _api.post(
              '/discussion/$discussionId/rating/$writeupId/${type.value}',
            ),
          ) ??
          const {};
      return VotingResponse(VotingResult.changed, asInt(root['rating']));
    } on ApiException catch (e) {
      if (!e.isForbidden) rethrow;
      return VotingResponse(
        e.code?.toLowerCase() == 'needsconfirmation'
            ? VotingResult.needsConfirmation
            : VotingResult.error,
      );
    }
  }

  Future<VotingInfo> getRatings(int discussionId, int writeupId) async {
    final raw = await _api.get('/discussion/$discussionId/rating/$writeupId');
    final positive = <String>[];
    final negative = <String>[];
    if (raw is List) {
      for (final v in raw.whereType<Map>()) {
        final nick = asString(v['username']);
        final tag = asString(v['tag'])?.toLowerCase();
        if (nick == null) continue;
        if (tag == 'positive') positive.add(nick);
        if (tag == 'negative') negative.add(nick);
      }
    }
    return VotingInfo(positive: positive, negative: negative);
  }

  Future<void> setReminder(int discussionId, int writeupId, bool newState) =>
      _api.post('/discussion/$discussionId/reminder/$writeupId/$newState');

  Future<void> deleteWriteup(int discussionId, int writeupId) =>
      _api.delete('/discussion/$discussionId/delete/$writeupId');

  Future<void> sendWriteup(
    int discussionId,
    String text, {
    MultipartFile? attachment,
  }) async {
    if (attachment != null) {
      await _api.multipart(
        '/file/upload',
        FormData.fromMap({
          'file': attachment,
          'file_type': 'discussion_attachment',
          'id_specific': discussionId.toString(),
        }),
      );
    }
    await _api.form('/discussion/$discussionId/send/text', {'content': text});
  }

  Future<String> getHeader(int discussionId) async {
    final root = asMap(await _api.get('/discussion/$discussionId')) ?? const {};
    final specific = asMap(
      asMap(root['discussion_common'])?['discussion_specific_data'],
    );
    final buffer = StringBuffer();
    for (final h in asMapList(specific?['header'])) {
      buffer
        ..write(asString(h['content']) ?? '')
        ..write('<br/>');
    }
    return buffer.toString();
  }

  Future<String> getBoard(int discussionId) async {
    final root =
        asMap(await _api.get('/discussion/$discussionId/content/home')) ??
        const {};
    final buffer = StringBuffer();
    for (final item in asMapList(root['items'])) {
      final content = asString(item['content']);
      if (content != null && content.trim().isNotEmpty) {
        buffer.write('<section>$content</section>');
      }
    }
    return buffer.toString();
  }

  Future<bool> setBookmark(
    int discussionId, {
    required bool book,
    int? categoryId,
  }) async {
    await _api.get(
      '/discussion/$discussionId/bookmark',
      query: {
        'new_state': book,
        if (book && categoryId != null) 'category': categoryId,
      },
    );
    return book;
  }

  Future<Writeup?> pollVote(
    int discussionId,
    int writeupId,
    String answerKey,
  ) async {
    final root =
        asMap(
          await _api.post(
            '/discussion/$discussionId/poll/$writeupId/vote/${Uri.encodeComponent(answerKey)}',
          ),
        ) ??
        const {};
    return Writeup.fromJson(root, myNick: nick());
  }
}

enum WriteupDirection { newest, newer, older }

enum VotingResult { changed, needsConfirmation, error }

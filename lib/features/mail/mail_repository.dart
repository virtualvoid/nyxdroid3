// author: juraj.suchan@gmail.com

import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/json_utils.dart';
import '../../core/models/status_counts.dart';
import '../../core/models/api_context.dart';
import '../../core/models/conversation.dart';
import '../../core/models/mail.dart';
import '../../core/models/mail_notification.dart';
import 'mail_page.dart';

class MailRepository {
  MailRepository(this._api, {required this.nick});

  final ApiClient _api;

  final String? Function() nick;

  Future<MailPage> getMail({
    int? lastId,
    String? filterUser,
    String? filterText,
  }) async {
    final query = <String, dynamic>{};
    if (lastId != null) {
      query['order'] = 'older_than';
      query['from_id'] = lastId + 1;
    }
    if (filterUser != null && filterUser.isNotEmpty) query['user'] = filterUser;
    if (filterText != null && filterText.isNotEmpty) query['text'] = filterText;

    final root =
        asMap(await _api.get('/mail', query: query.isEmpty ? null : query)) ??
        const {};
    final me = nick();

    return MailPage(
      mails: [
        for (final post in asMapList(root['posts']))
          ?Mail.fromJson(post, myNick: me),
      ],
      conversations: _conversations(root),
      context: ApiContext.fromRoot(root),
    );
  }

  Future<List<Conversation>> getConversations() async {
    final root = asMap(await _api.get('/mail')) ?? const {};
    return _conversations(root);
  }

  List<Conversation> _conversations(Map<String, dynamic> root) => [
    for (final c in asMapList(root['conversations'])) ?Conversation.fromJson(c),
  ];

  Future<StatusCounts> getStatus() async {
    final root = asMap(await _api.get('/status')) ?? const {};
    final user = asMap(root['user']);
    if (user == null) return const StatusCounts();
    return StatusCounts(
      mail: asInt(user['mail_unread']) ?? 0,
      mailLastFrom: asString(user['mail_last_from']),
      notifications: asInt(user['notifications_unread']) ?? 0,
    );
  }

  Future<MailNotification> getNotification() async {
    final status = await getStatus();
    return MailNotification(count: status.mail, lastFrom: status.mailLastFrom);
  }

  Future<void> sendMail(
    String recipient,
    String message, {
    MultipartFile? attachment,
  }) async {
    if (attachment != null) {
      await _api.multipart(
        '/file/upload',
        FormData.fromMap({
          'file': attachment,
          'file_type': 'mail_attachment',
          'id_specific': '0',
        }),
      );
    }
    await _api.form('/mail/send', {'recipient': recipient, 'message': message});
  }

  Future<void> setReminder(int mailId, bool newState) =>
      _api.post('/mail/reminder/$mailId/$newState');

  Future<void> deleteMail(int mailId) => _api.delete('/mail/delete/$mailId');

  Future<List<String>> searchUsers(String prefix) async {
    final root =
        asMap(
          await _api.get('/search/username/${Uri.encodeComponent(prefix)}'),
        ) ??
        const {};
    final seen = <String>{};
    final result = <String>[];
    for (final group in const ['exact', 'friends', 'others']) {
      for (final row in asMapList(root[group])) {
        final name =
            asString(row['username']) ??
            asString(asMap(row['user'])?['username']);
        if (name != null && seen.add(name.toLowerCase())) result.add(name);
      }
    }
    return result;
  }
}

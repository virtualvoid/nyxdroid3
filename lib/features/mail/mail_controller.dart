// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/guarded_loader.dart';
import '../../core/latest_request_guard.dart';
import '../../core/models/mail.dart';
import '../../core/models/mail_notification.dart';
import '../../core/providers.dart';
import '../notifications/status_counts_provider.dart';
import '../../core/search_text.dart';
import 'mail_page.dart';
import 'mail_repository.dart';
import 'mail_state.dart';

class MailController extends Notifier<MailState>
    with LatestRequestGuard, GuardedLoader<MailState> {
  MailRepository get _repo => ref.read(mailRepositoryProvider);

  @override
  MailState build() => const MailState();

  Future<void> loadInitial({int? mailId}) => _loadFresh(startAt: mailId);

  Future<void> refresh() => _loadFresh();

  Future<void> search(String text) {
    final parts = splitSearch(text.trim());
    if (parts == null) return Future.value();
    return _loadFresh(filterUser: parts.user, filterText: parts.text);
  }

  Future<void> filterByNick(String nick) => _loadFresh(filterUser: nick);

  Future<void> _loadFresh({
    int? startAt,
    String? filterUser,
    String? filterText,
  }) => guarded<MailPage>(
    start: (s) =>
        s.copyWith(loading: true, loadingMore: false, clearError: true),
    fetch: () => _repo.getMail(
      lastId: startAt,
      filterUser: filterUser,
      filterText: filterText,
    ),
    onData: (s, page) => MailState(
      mails: page.mails,
      conversations: s.conversations,
      filterUser: filterUser,
      filterText: filterText,
    ),
    onError: (s, e) => s.copyWith(loading: false, error: e),
  );

  Future<void> loadMore() async {
    if (state.loading ||
        state.loadingMore ||
        state.reachedEnd ||
        state.mails.isEmpty) {
      return;
    }
    await guarded<MailPage>(
      start: (s) => s.copyWith(loadingMore: true, clearError: true),
      fetch: () => _repo.getMail(
        lastId: state.mails.last.id,
        filterUser: state.filterUser,
        filterText: state.filterText,
      ),
      onData: (s, page) {
        final known = {for (final m in s.mails) m.id};
        final fresh = page.mails.where((m) => !known.contains(m.id)).toList();
        return s.copyWith(
          mails: [...s.mails, ...fresh],
          loadingMore: false,
          reachedEnd: fresh.isEmpty,
        );
      },
      onError: (s, e) => s.copyWith(loadingMore: false, error: e),
    );
  }

  Future<void> loadConversations() async {
    state = state.copyWith(conversationsLoading: true);
    final list = await attempt(
      _repo.getConversations,
      (s, e) => s.copyWith(conversationsLoading: false, error: e),
    );
    if (list != null) {
      state = state.copyWith(conversations: list, conversationsLoading: false);
    }
  }

  Future<void> toggleReminder(int mailId) async {
    final index = state.mails.indexWhere((m) => m.id == mailId);
    if (index == -1) return;
    final newState = !state.mails[index].isReminded;

    final ok = await attempt(() async {
      await _repo.setReminder(mailId, newState);
      return true;
    }, (s, e) => s.copyWith(error: e));
    if (ok == true) _replace(mailId, (m) => m.copyWith(isReminded: newState));
  }

  Future<void> deleteMail(int mailId) async {
    final before = state.mails;
    final index = before.indexWhere((m) => m.id == mailId);
    if (index == -1) return;

    state = state.copyWith(
      mails: [
        for (final m in before)
          if (m.id != mailId) m,
      ],
    );

    await attempt(() => _repo.deleteMail(mailId), (s, e) {
      final restored = [...s.mails]
        ..insert(index.clamp(0, s.mails.length), before[index]);
      return s.copyWith(mails: restored, error: e);
    });
  }

  void _replace(int mailId, Mail Function(Mail) change) {
    state = state.copyWith(
      mails: [for (final m in state.mails) m.id == mailId ? change(m) : m],
    );
  }
}

final mailNotificationProvider = FutureProvider.autoDispose((ref) async {
  final status = await ref.watch(statusCountsProvider.future);
  return MailNotification(count: status.mail, lastFrom: status.mailLastFrom);
});

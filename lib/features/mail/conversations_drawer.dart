// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/avatar.dart';
import '../../app/widgets/empty_refresh_list.dart';
import '../../core/format.dart';
import 'mail_state.dart';

class ConversationsDrawer extends ConsumerWidget {
  const ConversationsDrawer({super.key, required this.onSelected});

  final void Function(String nick) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mailControllerProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 4,
              child: state.conversationsLoading
                  ? const LinearProgressIndicator()
                  : null,
            ),
            Expanded(
              child: state.conversations.isEmpty
                  ? EmptyRefreshList(
                      loading: state.conversationsLoading,
                      error: state.error,
                      onRetry: ref
                          .read(mailControllerProvider.notifier)
                          .loadConversations,
                    )
                  : ListView.builder(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, i) {
                        final c = state.conversations[i];
                        final scheme = Theme.of(context).colorScheme;
                        return ListTile(
                          key: Key('conversation_${c.nick}'),
                          leading: NickAvatar(nick: c.nick, size: 36),
                          title: Text(
                            c.nick,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            c.time == null ? '' : formatDateTime(c.time!),
                            style: const TextStyle(fontSize: 11),
                          ),
                          trailing: Icon(
                            c.incoming ? Icons.call_received : Icons.call_made,
                            key: Key(
                              c.incoming
                                  ? 'conversation_in_${c.nick}'
                                  : 'conversation_out_${c.nick}',
                            ),
                            size: 18,
                            color: c.incoming
                                ? scheme.primary
                                : scheme.onSurfaceVariant,
                          ),
                          onTap: () => onSelected(c.nick),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

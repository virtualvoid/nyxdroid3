// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/widgets/common_widgets.dart';
import '../../core/models/writeup.dart';
import '../../core/drafts/draft_store.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../compose/compose_layout.dart';
import '../compose/draft_banner.dart';
import '../compose/draft_saver.dart';
import '../compose/reply_card.dart';
import '../compose/reply_chips.dart';
import 'compose_args.dart';
import 'compose_controller.dart';
import 'compose_result.dart';
import 'content_html.dart';
import 'post_html.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({super.key, required this.args});

  final ComposeArgs args;

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  final _text = TextEditingController();
  final _focus = FocusNode();

  final List<Writeup> _targets = [];
  late final DraftSaver _draft;
  bool _draftRestored = false;

  ComposeArgs get _args => widget.args;

  ComposeController get _controller =>
      ref.read(composeControllerProvider(_args.discussionId).notifier);

  @override
  void initState() {
    super.initState();

    _draft = DraftSaver(
      store: ref.read(draftStoreProvider),
      key: 'discussion:${_args.discussionId}',
      controller: _text,
    );
    _draft.restore().then((restored) {
      if (restored && mounted) setState(() => _draftRestored = true);
    });

    if (_args.replying.length == 1) {
      _targets.add(_args.replying.first);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _draft.dispose();
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _addTarget(Writeup wu) {
    if (!_targets.any((t) => t.id == wu.id)) {
      setState(() => _targets.add(wu));
    }
    _focus.requestFocus();
  }

  void _removeTarget(String id) =>
      setState(() => _targets.removeWhere((t) => '${t.id}' == id));

  Future<void> _pickAttachment() async {
    final file = await ref.read(attachmentPickerProvider)();
    if (file != null) _controller.setAttachment(file.path, file.name);
  }

  Future<void> _send() async {
    final body = _text.text;
    final hasAttachment = ref
        .read(composeControllerProvider(_args.discussionId))
        .hasAttachment;
    final tags = _targets.map((t) => replyTag(t.nick, t.id)).join();
    final outcome = await _controller.send(
      body.isEmpty && !hasAttachment ? '' : '$tags$body',
    );
    if (!mounted) return;
    final error = ref.read(composeControllerProvider(_args.discussionId)).error;
    if (reportSendOutcome(context, outcome, error)) {
      await _draft.clear();
      if (!mounted) return;
      context.pop<ComposeResult>(const ComposeSent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(composeControllerProvider(_args.discussionId));
    final appearance = ref.watch(appearanceProvider);

    ref.listen(
      composeControllerProvider(_args.discussionId).select((s) => s.problem),
      (_, p) {
        if (p == AttachmentProblem.unreadable) {
          showSnack(context, l10n.fileDoesntExistsOrCantRead);
        }
      },
    );

    final single = _args.replying.length == 1 ? _args.replying.first : null;
    final canVote = single != null && !single.isMine;

    return ComposeLayout(
      title: _args.discussionName,
      state: state,
      textController: _text,
      focusNode: _focus,
      onAttach: _pickAttachment,
      onSend: _send,
      onRemoveAttachment: _controller.removeAttachment,
      extraActions: [
        if (canVote) ...[
          IconButton(
            key: const Key('compose_voteup'),
            tooltip: l10n.thumbsUp,
            icon: const Icon(Icons.thumb_up_alt_outlined),
            onPressed: () => context.pop<ComposeResult>(
              ComposeVote(single.id, VotingType.positive),
            ),
          ),
          IconButton(
            key: const Key('compose_votedown'),
            tooltip: l10n.thumbsDown,
            icon: const Icon(Icons.thumb_down_alt_outlined),
            onPressed: () => context.pop<ComposeResult>(
              ComposeVote(single.id, VotingType.negative),
            ),
          ),
        ],
      ],
      draftBanner: _draftRestored
          ? DraftBanner(
              message: l10n.draftRestored,
              discardLabel: l10n.draftDiscard,
              onDiscard: () {
                setState(() => _draftRestored = false);
                _draft.discard();
              },
            )
          : null,
      replyBar: ReplyChips(
        items: [for (final t in _targets) (id: '${t.id}', label: t.nick)],
        onRemove: _removeTarget,
      ),
      replies: [
        for (final wu in _args.replying)
          ReplyCard(
            key: Key('reply_card_${wu.id}'),
            nick: wu.nick,
            time: wu.time,
            onTap: () => _addTarget(wu),
            child: PostHtml(prepareContent(wu.content), appearance),
          ),
      ],
    );
  }
}

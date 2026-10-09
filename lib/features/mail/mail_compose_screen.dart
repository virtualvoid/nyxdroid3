// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/widgets/common_widgets.dart';
import '../../core/models/mail.dart';
import '../../core/drafts/draft_store.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../compose/compose_base.dart';
import '../compose/compose_layout.dart';
import '../compose/draft_banner.dart';
import '../compose/draft_saver.dart';
import '../compose/reply_card.dart';
import '../compose/reply_chips.dart';
import '../discussion/content_html.dart';
import '../discussion/post_html.dart';
import 'mail_compose.dart';
import 'mail_compose_args.dart';
import 'mail_compose_controller.dart';

class MailComposeScreen extends ConsumerStatefulWidget {
  const MailComposeScreen({super.key, required this.args});

  final MailComposeArgs args;

  @override
  ConsumerState<MailComposeScreen> createState() => _MailComposeScreenState();
}

class _MailComposeScreenState extends ConsumerState<MailComposeScreen> {
  final _text = TextEditingController();
  final _focus = FocusNode();
  TextEditingController? _recipientField;
  int _searchSeq = 0;
  late bool _quote;
  late final DraftSaver _draft;
  bool _draftRestored = false;

  MailComposeArgs get _args => widget.args;
  Mail? get _reply => _args.replyTo;

  MailComposeController get _controller =>
      ref.read(mailComposeControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    _quote = _reply != null && _args.quoteReply;
    _draft = DraftSaver(
      store: ref.read(draftStoreProvider),
      key:
          'mail:${_reply?.nick ?? (_args.recipient.isEmpty ? 'new' : _args.recipient)}',
      controller: _text,
    );
    _draft.restore().then((restored) {
      if (restored && mounted) setState(() => _draftRestored = true);
    });
    if (_reply != null || _args.recipient.isNotEmpty) {
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

  Future<Iterable<String>> _options(TextEditingValue value) async {
    final query = value.text.trim();
    final seq = ++_searchSeq;
    if (query.length < 2) return const [];

    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (seq != _searchSeq) return const [];

    try {
      return await ref.read(mailRepositoryProvider).searchUsers(query);
    } catch (_) {
      return const [];
    }
  }

  Future<void> _pickAttachment() async {
    final file = await ref.read(attachmentPickerProvider)();
    if (file != null) _controller.setAttachment(file.path, file.name);
  }

  Future<void> _send() async {
    _controller.recipient =
        _reply?.nick ?? _recipientField?.text ?? _args.recipient;
    final body = _text.text;
    final hasAttachment = ref.read(mailComposeControllerProvider).hasAttachment;
    final tag = _quote ? mailReplyTag(_reply!.id) : '';
    final outcome = await _controller.send(
      body.isEmpty && !hasAttachment ? '' : '$tag$body',
    );
    if (!mounted) return;
    final error = ref.read(mailComposeControllerProvider).error;
    if (reportSendOutcome(context, outcome, error)) {
      await _draft.clear();
      if (!mounted) return;
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(mailComposeControllerProvider);
    final appearance = ref.watch(appearanceProvider);

    ref.listen(mailComposeControllerProvider.select((s) => s.problem), (_, p) {
      if (p == AttachmentProblem.unreadable) {
        showSnack(context, l10n.fileDoesntExistsOrCantRead);
      }
    });

    return ComposeLayout(
      title: l10n.menuMail,
      state: state,
      textController: _text,
      focusNode: _focus,
      onAttach: _pickAttachment,
      onSend: _send,
      onRemoveAttachment: _controller.removeAttachment,
      header: _reply != null
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Autocomplete<String>(
                initialValue: TextEditingValue(text: _args.recipient),
                optionsBuilder: _options,
                onSelected: (_) => _focus.requestFocus(),
                fieldViewBuilder:
                    (context, controller, focusNode, onSubmitted) {
                      _recipientField = controller;
                      return TextField(
                        key: const Key('mail_recipient'),
                        controller: controller,
                        focusNode: focusNode,
                        autofocus: _args.recipient.isEmpty,
                        decoration: InputDecoration(
                          hintText: l10n.enterRecipientNick,
                          isDense: true,
                          filled: true,
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      );
                    },
              ),
            ),
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
      replyBar: _quote
          ? ReplyChips(
              items: [(id: 'm${_reply!.id}', label: _reply!.nick)],
              onRemove: (_) => setState(() => _quote = false),
            )
          : null,
      replies: [
        if (_reply case final mail?)
          ReplyCard(
            key: Key('reply_card_${mail.id}'),
            nick: mail.nick,
            time: mail.time,
            child: PostHtml(replaceVideoTags(mail.content), appearance),
          ),
      ],
    );
  }
}

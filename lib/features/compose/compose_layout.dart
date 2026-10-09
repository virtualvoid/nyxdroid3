// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/widgets/common_widgets.dart';
import '../../l10n/app_localizations.dart';
import 'attachment_card.dart';
import 'compose_base.dart';
import 'compose_input_bar.dart';
import 'compose_state.dart';

class ComposeLayout extends StatelessWidget {
  const ComposeLayout({
    super.key,
    required this.title,
    required this.state,
    required this.textController,
    required this.focusNode,
    required this.onAttach,
    required this.onSend,
    required this.onRemoveAttachment,
    this.extraActions = const [],
    this.header,
    this.replies = const [],
    this.replyBar,
    this.draftBanner,
  });

  final String title;
  final ComposeState state;
  final TextEditingController textController;
  final FocusNode focusNode;
  final VoidCallback onAttach;
  final VoidCallback onSend;
  final VoidCallback onRemoveAttachment;

  final List<Widget> extraActions;

  final Widget? header;

  final List<Widget> replies;

  final Widget? replyBar;

  final Widget? draftBanner;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: extraActions,
        bottom: loadingBar(state.sending),
      ),
      body: Column(
        children: [
          ?header,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                ...replies,
                if (state.hasAttachment)
                  AttachmentCard(
                    path: state.attachmentPath!,
                    name: state.attachmentName ?? '',
                    onRemove: onRemoveAttachment,
                  ),
              ],
            ),
          ),
          ?draftBanner,
          ?replyBar,
          ComposeInputBar(
            controller: textController,
            focusNode: focusNode,
            hint: l10n.enterYourMessage,
            attachTooltip: l10n.attachment,
            sendTooltip: l10n.send,
            sending: state.sending,
            onAttach: onAttach,
            onSend: onSend,
          ),
        ],
      ),
    );
  }
}

bool reportSendOutcome(
  BuildContext context,
  SendOutcome outcome,
  Object? error,
) {
  final l10n = AppLocalizations.of(context);
  switch (outcome) {
    case SendOutcome.empty:
      showSnack(context, l10n.andWhatAboutMessage);
    case SendOutcome.noRecipient:
      showSnack(context, l10n.andWhatAboutNick);
    case SendOutcome.failed:
      showSnack(
        context,
        error == null
            ? l10n.somethingTerribleHappenedToNyx
            : '${l10n.somethingTerribleHappenedToNyx} $error',
      );
    case SendOutcome.sent:
      showSnack(context, l10n.sent);
      return true;
  }
  return false;
}

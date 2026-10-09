// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';
import '../../app/avatar.dart';
import '../../app/widgets/entry_header.dart';
import '../../app/widgets/feed_card.dart';
import '../../core/models/writeup.dart';
import '../../l10n/app_localizations.dart';
import 'content_html.dart';
import 'poll_answers.dart';
import 'post_html.dart';
import 'spoiler_notice.dart';
import 'vote_bar.dart';

class WriteupTile extends StatefulWidget {
  const WriteupTile({
    super.key,
    required this.writeup,
    required this.appearance,
    required this.now,
    this.onVote,
    this.onPollVote,
    this.onLink,
    this.onImage,
    this.onTap,
    this.onLongPress,
    this.selectionVisible = false,
    this.selected = false,
    this.onSelectedChanged,
  });

  final Writeup writeup;
  final Appearance appearance;

  final DateTime now;
  final void Function(VotingType type)? onVote;
  final void Function(String answerKey)? onPollVote;
  final void Function(String url)? onLink;
  final void Function(String url)? onImage;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final bool selectionVisible;
  final bool selected;
  final ValueChanged<bool>? onSelectedChanged;

  @override
  State<WriteupTile> createState() => _WriteupTileState();
}

class _WriteupTileState extends State<WriteupTile> {
  bool _spoilerRevealed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wu = widget.writeup;
    final ap = widget.appearance;

    final tintUnread = wu.unread && ap.entryUnreadColor == null;

    return FeedCard(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      highlighted: widget.selected || tintUnread,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NickAvatar(nick: wu.nick, size: 40),
              const SizedBox(width: 10),
              Expanded(
                child: EntryHeader(
                  nick: wu.nick,
                  time: wu.time,
                  unread: wu.unread,
                  location: wu.location,
                  appearance: ap,
                  now: widget.now,
                ),
              ),
              if (widget.selectionVisible && !wu.isPoll)
                SizedBox(
                  height: 24,
                  width: 40,
                  child: Checkbox(
                    key: const Key('wu_select'),
                    value: widget.selected,
                    onChanged: (v) =>
                        widget.onSelectedChanged?.call(v ?? false),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _body(l10n, wu, ap),
          if (wu.poll != null)
            PollAnswers(poll: wu.poll!, onVote: widget.onPollVote),
          if (ap.displayVotingThumbs)
            VoteBar(writeup: wu, appearance: ap, onVote: widget.onVote),
        ],
      ),
    );
  }

  Widget _body(AppLocalizations l10n, Writeup wu, Appearance ap) {
    final poll = wu.poll;
    if (poll != null) {
      return PostHtml(
        '<b>${poll.question}</b><br/>${poll.instructions}',
        ap,
        onLink: widget.onLink,
        onImage: widget.onImage,
      );
    }

    if (hasSpoiler(wu.content) && !_spoilerRevealed) {
      return SpoilerNotice(
        key: const Key('wu_spoiler'),
        text: l10n.spoilerAlert,
        fontSize: ap.fontSize,
        onTap: () => setState(() => _spoilerRevealed = true),
      );
    }
    return PostHtml(
      prepareContent(wu.content),
      ap,
      onLink: widget.onLink,
      onImage: widget.onImage,
    );
  }
}

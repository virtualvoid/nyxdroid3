// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';
import '../../app/avatar.dart';
import '../../app/widgets/entry_header.dart';
import '../../core/models/mail.dart';
import '../discussion/content_html.dart';
import '../discussion/post_html.dart';

class MailTile extends StatelessWidget {
  const MailTile({
    super.key,
    required this.mail,
    required this.appearance,
    required this.now,
    this.onTap,
    this.onLongPress,
    this.onLink,
    this.onImage,
  });

  final Mail mail;
  final Appearance appearance;
  final DateTime now;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final void Function(String url)? onLink;
  final void Function(String url)? onImage;

  @override
  Widget build(BuildContext context) {
    final outgoing = !mail.incoming;
    final scheme = Theme.of(context).colorScheme;

    const round = Radius.circular(18);
    const tail = Radius.circular(4);

    final bubble = Material(
      key: Key(outgoing ? 'mail_bubble_out' : 'mail_bubble_in'),
      color: outgoing ? scheme.primaryContainer : scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.only(
        topLeft: round,
        topRight: round,
        bottomLeft: outgoing ? round : tail,
        bottomRight: outgoing ? tail : round,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EntryHeader(
                nick: mail.nick,
                time: mail.time,
                unread: mail.unread,
                location: mail.location,
                appearance: appearance,
                now: now,
                mirrored: outgoing,
              ),
              const SizedBox(height: 4),
              PostHtml(
                replaceVideoTags(mail.content),
                appearance,
                onLink: onLink,
                onImage: onImage,
              ),
              if (mail.isReminded)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.alarm,
                      key: const Key('mail_reminder_icon'),
                      size: 16,
                      color: scheme.tertiary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    final avatar = Padding(
      padding: EdgeInsets.only(
        left: outgoing ? 8 : 0,
        right: outgoing ? 0 : 8,
        bottom: 2,
      ),
      child: NickAvatar(nick: mail.nick),
    );

    final body = Expanded(
      child: Align(
        alignment: outgoing ? Alignment.centerRight : Alignment.centerLeft,
        child: FractionallySizedBox(widthFactor: 0.92, child: bubble),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: outgoing ? [body, avatar] : [avatar, body],
      ),
    );
  }
}

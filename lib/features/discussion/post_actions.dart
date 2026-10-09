// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/widgets/action_item.dart';
import '../../core/models/writeup.dart';
import '../../l10n/app_localizations.dart';

enum PostAction {
  reply,
  sendMail,
  viewReplies,
  viewRating,
  copy,
  gallery,
  reminder,
  delete,
  copyLink,
}

Future<PostAction?> showPostActions(BuildContext context, Writeup wu) {
  final l10n = AppLocalizations.of(context);
  return showActionSheet<PostAction>(context, [
    ActionItem(PostAction.reply, Icons.reply, l10n.reply),
    ActionItem(PostAction.sendMail, Icons.mail_outline, l10n.sendMail),
    ActionItem(PostAction.viewReplies, Icons.forum_outlined, l10n.viewReplies),
    ActionItem(PostAction.viewRating, Icons.star_half, l10n.rating),
    ActionItem(PostAction.copy, Icons.copy, l10n.copy),
    ActionItem(
      PostAction.gallery,
      Icons.photo_library_outlined,
      l10n.viewAsGallery,
    ),
    ActionItem(
      PostAction.reminder,
      Icons.alarm,
      l10n.reminder,
      trailing: wu.isReminded ? const Icon(Icons.check) : null,
    ),
    if (wu.canDelete)
      ActionItem(PostAction.delete, Icons.delete_outline, l10n.delete),
    ActionItem(PostAction.copyLink, Icons.link, l10n.copyLink),
  ]);
}

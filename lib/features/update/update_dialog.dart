// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../discussion/link_actions.dart';
import 'app_release.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({
    super.key,
    required this.release,
    required this.currentVersion,
    required this.onSkip,
  });

  final AppRelease release;
  final String currentVersion;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final notes = release.plainNotes;
    return AlertDialog(
      key: const Key('update_dialog'),
      title: Text(l10n.updateAvailableTitle(release.version)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.updateCurrentVersion(currentVersion),
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(notes, key: const Key('update_notes')),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key('update_skip'),
          onPressed: () {
            onSkip();
            Navigator.of(context).pop();
          },
          child: Text(l10n.updateSkip),
        ),
        TextButton(
          key: const Key('update_later'),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.updateLater),
        ),
        FilledButton(
          key: const Key('update_download'),
          onPressed: () {
            openExternal(context, release.downloadUrl);
            Navigator.of(context).pop();
          },
          child: Text(l10n.updateDownload),
        ),
      ],
    );
  }
}

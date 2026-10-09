// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'ratings_column.dart';
import 'ratings_provider.dart';

class RatingsDialog extends ConsumerWidget {
  const RatingsDialog({
    super.key,
    required this.discussionId,
    required this.writeupId,
  });

  final int discussionId;
  final int writeupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final info = ref.watch(
      ratingsProvider((discussionId: discussionId, writeupId: writeupId)),
    );

    return AlertDialog(
      title: Text(l10n.rating),
      content: SizedBox(
        width: double.maxFinite,
        child: info.when(
          loading: () => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('$e'),
          data: (v) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RatingsColumn(
                  sign: '+',
                  nicks: v.positive,
                  empty: l10n.noOneAtThisTime,
                ),
              ),
              Expanded(
                child: RatingsColumn(
                  sign: '-',
                  nicks: v.negative,
                  empty: l10n.noOneAtThisTime,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showRatingsDialog(
  BuildContext context, {
  required int discussionId,
  required int writeupId,
}) => showDialog<void>(
  context: context,
  builder: (_) =>
      RatingsDialog(discussionId: discussionId, writeupId: writeupId),
);

// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class EmptyRefreshList extends StatelessWidget {
  const EmptyRefreshList({
    super.key,
    required this.loading,
    this.error,
    this.onRetry,
  });

  final bool loading;
  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final failed = error != null && onRetry != null;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        if (!loading)
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 32, right: 32),
            child: failed
                ? Column(
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        key: const Key('error_icon'),
                        size: 72,
                        color: scheme.error,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.errorLoading,
                        key: const Key('error_title'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$error',
                        key: const Key('error_detail'),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: scheme.outline),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonalIcon(
                        key: const Key('retry_button'),
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.tryAgain),
                        onPressed: onRetry,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        key: const Key('empty_icon'),
                        size: 72,
                        color: scheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.noData,
                        key: const Key('empty_text'),
                        style: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(color: scheme.outline),
                      ),
                    ],
                  ),
          ),
      ],
    );
  }
}

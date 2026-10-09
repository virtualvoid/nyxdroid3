// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import 'content_html.dart';
import 'post_html.dart';

final discussionHeaderProvider = FutureProvider.autoDispose.family<String, int>(
  (ref, id) {
    ref.keepAlive();
    return ref.watch(discussionRepositoryProvider).getHeader(id);
  },
);

final discussionBoardProvider = FutureProvider.autoDispose.family<String, int>((
  ref,
  id,
) {
  ref.keepAlive();
  return ref.watch(discussionRepositoryProvider).getBoard(id);
});

class HtmlTab extends ConsumerWidget {
  const HtmlTab({
    super.key,
    required this.provider,
    required this.emptyText,
    this.onLink,
    this.onImage,
  });

  final FutureProvider<String> provider;
  final String Function(AppLocalizations l10n) emptyText;
  final void Function(String url)? onLink;
  final void Function(String url)? onImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final appearance = ref.watch(appearanceProvider);
    final data = ref.watch(provider);

    return data.when(
      loading: () => const Center(
        child: CircularProgressIndicator(key: Key('tab_loading')),
      ),
      error: (_, _) => Center(
        child: Text(l10n.unspecifiedDataError, key: const Key('tab_error')),
      ),
      data: (html) {
        if (html.trim().isEmpty) {
          return Center(
            child: Text(emptyText(l10n), key: const Key('tab_empty')),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: PostHtml(
            replaceVideoTags(html),
            appearance,
            onLink: onLink,
            onImage: onImage,
          ),
        );
      },
    );
  }
}

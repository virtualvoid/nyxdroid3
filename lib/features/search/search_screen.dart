// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_drawer.dart';
import '../../app/drawer_edge.dart';
import '../../app/widgets/common_widgets.dart';
import '../../app/widgets/empty_refresh_list.dart';
import '../../app/widgets/search_field.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../discussion/link_actions.dart';
import '../last/last_tile.dart';
import 'post_search_controller.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _query = TextEditingController();
  final _scroll = ScrollController();

  PostSearchController get _controller =>
      ref.read(postSearchControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _query.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!_scroll.hasClients) return;
    final pos = _scroll.position;
    if (pos.maxScrollExtent - pos.pixels < 400) _controller.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final state = ref.watch(postSearchControllerProvider);
    final appearance = ref.watch(appearanceProvider);

    listenForErrors(
      ref,
      context,
      postSearchControllerProvider.select((s) => s.error),
    );

    ref.listen(postSearchControllerProvider.select((s) => s.items.length), (
      _,
      _,
    ) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _maybeLoadMore();
      });
    });

    final Widget body;
    if (!state.searched) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.manage_search,
                key: const Key('search_prompt_icon'),
                size: 72,
                color: scheme.outline,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.searchHelp,
                key: const Key('search_help'),
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.outline),
              ),
            ],
          ),
        ),
      );
    } else if (state.items.isEmpty) {
      body = EmptyRefreshList(
        loading: state.loading,
        error: state.error,
        onRetry: () => _controller.search(_query.text),
      );
    } else {
      body = ListView.builder(
        controller: _scroll,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: state.items.length,
        itemBuilder: (context, i) {
          final post = state.items[i];
          return LastTile(
            key: ValueKey(post.writeup.id),
            post: post,
            appearance: appearance,
            onTap: () => openDiscussion(
              context,
              post.discussionId,
              postId: post.writeup.id + 1,
            ),
            onLink: (url) => openExternal(context, url),
          );
        },
      );
    }

    return Scaffold(
      drawer: const AppDrawer(),
      drawerEdgeDragWidth: drawerEdgeDragWidth(context),
      appBar: AppBar(
        title: SearchField(
          controller: _query,
          hint: l10n.search,
          onSubmitted: _controller.search,
        ),
        bottom: loadingBar(state.loading || state.loadingMore),
      ),
      body: body,
    );
  }
}

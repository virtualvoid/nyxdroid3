// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/widgets/common_widgets.dart';
import '../../app/widgets/empty_refresh_list.dart';
import '../../core/network_image.dart';
import '../discussion/compose_args.dart';
import '../discussion/compose_result.dart';
import 'gallery_args.dart';
import 'gallery_grid_controller.dart';
import 'gallery_grid_state.dart';
import 'gallery_image.dart';

class GalleryGridScreen extends ConsumerStatefulWidget {
  const GalleryGridScreen({super.key, required this.discussionId});

  final int discussionId;

  @override
  ConsumerState<GalleryGridScreen> createState() => _GalleryGridScreenState();
}

class _GalleryGridScreenState extends ConsumerState<GalleryGridScreen> {
  static const _columns = 3;
  static const _gap = 6.0;

  final _scroll = ScrollController();

  GalleryGridController get _controller =>
      ref.read(galleryGridControllerProvider(widget.discussionId).notifier);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
    Future.microtask(_controller.loadFirst);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!_scroll.hasClients) return;
    final pos = _scroll.position;
    if (pos.maxScrollExtent - pos.pixels < 400) _controller.loadMore();
  }

  Future<void> _open(GalleryGridState state, int index) async {
    final writeupId = await context.push<int>(
      Routes.gallery,
      extra: GalleryArgs(state.images, startIndex: index),
    );
    if (!mounted ||
        writeupId == null ||
        writeupId == 0 ||
        !_scroll.hasClients) {
      return;
    }

    final target = state.images.indexWhere((i) => i.writeupId == writeupId);
    if (target == -1) return;
    final width = MediaQuery.sizeOf(context).width;
    final tile = (width - _gap * (_columns + 1)) / _columns;
    final row = target ~/ _columns;
    _scroll.jumpTo(
      (row * (tile + _gap)).clamp(0, _scroll.position.maxScrollExtent),
    );
  }

  Future<void> _reply(GalleryGridState state, GalleryImage image) async {
    final wu = state.writeups[image.writeupId];
    if (wu == null) return;
    await context.push<ComposeResult>(
      Routes.compose,
      extra: ComposeArgs(
        discussionId: widget.discussionId,
        discussionName: state.name,
        replying: [wu],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(galleryGridControllerProvider(widget.discussionId));
    final scheme = Theme.of(context).colorScheme;

    listenForErrors(
      ref,
      context,
      galleryGridControllerProvider(widget.discussionId).select((s) => s.error),
    );

    ref.listen(
      galleryGridControllerProvider(widget.discussionId)
          .select((s) => s.images.length),
      (_, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _maybeLoadMore();
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(state.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        bottom: loadingBar(state.loading),
      ),
      body: RefreshIndicator(
        onRefresh: _controller.loadFirst,
        child: state.images.isEmpty
            ? EmptyRefreshList(
                loading: state.loading,
                error: state.error,
                onRetry: _controller.loadFirst,
              )
            : GridView.builder(
                controller: _scroll,
                padding: const EdgeInsets.all(_gap),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _columns,
                  mainAxisSpacing: _gap,
                  crossAxisSpacing: _gap,
                ),
                itemCount: state.images.length,
                itemBuilder: (context, i) {
                  final image = state.images[i];
                  return ClipRRect(
                    key: Key('grid_item_$i'),
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image(
                          image: ref.read(networkImageProvider)(image.thumbUrl),
                          fit: BoxFit.cover,
                          frameBuilder: (_, child, frame, sync) =>
                              frame == null && !sync
                              ? ColoredBox(color: scheme.surfaceContainerHigh)
                              : child,
                          errorBuilder: (_, _, _) => ColoredBox(
                            color: scheme.surfaceContainerHigh,
                            child: Icon(
                              Icons.broken_image,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (image.unread)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Icon(
                              Icons.fiber_manual_record,
                              key: Key('grid_unread_$i'),
                              size: 12,
                              color: scheme.primary,
                            ),
                          ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _open(state, i),
                              onLongPress: () => _reply(state, image),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

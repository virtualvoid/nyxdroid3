// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../app/widgets/common_widgets.dart';
import '../../core/network_image.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../discussion/link_actions.dart';
import 'gallery_args.dart';
import 'gallery_counter.dart';
import 'gallery_image.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key, required this.args});

  final GalleryArgs args;

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  late final PageController _pages;
  late int _index;
  bool _chrome = true;

  List<GalleryImage> get _images => widget.args.images;

  @override
  void initState() {
    super.initState();
    _index = widget.args.startIndex.clamp(0, _images.length - 1);
    _pages = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  String _title() {
    final img = _images[_index];
    final thumbs = ref.read(appPrefsProvider).displayVotingThumbs;
    return '${img.unread ? 'N ' : ''}${img.rating != 0 && thumbs ? '(${img.rating}) ' : ''}${img.nick}';
  }

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: _images[_index].url));
    if (mounted) showSnack(context, AppLocalizations.of(context).linkCopied);
  }

  void _close(int writeupId) => context.pop<int>(writeupId);

  void _toggleChrome() => setState(() => _chrome = !_chrome);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedOpacity(
          key: const Key('gallery_chrome'),
          duration: const Duration(milliseconds: 200),
          opacity: _chrome ? 1 : 0,
          child: IgnorePointer(
            ignoring: !_chrome,
            child: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              flexibleSpace: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black87, Colors.black.withValues(alpha: 0)],
                  ),
                ),
              ),
              title: Text(_title(), key: const Key('gallery_title')),
              actions: [
                IconButton(
                  key: const Key('gallery_browser'),
                  tooltip: l10n.galleryOpenBrowser,
                  icon: const Icon(Icons.open_in_browser),
                  onPressed: () => openExternal(context, _images[_index].url),
                ),
                PopupMenuButton<String>(
                  key: const Key('gallery_menu'),
                  onSelected: (v) {
                    if (v == 'begin') _close(_images.first.writeupId);
                    if (v == 'current') _close(_images[_index].writeupId);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      key: const Key('gallery_begin'),
                      value: 'begin',
                      child: Text(l10n.galleryBegin),
                    ),
                    PopupMenuItem(
                      key: const Key('gallery_current'),
                      value: 'current',
                      child: Text(l10n.galleryCurrent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            key: const Key('gallery_body'),
            onLongPress: _copyLink,
            child: PhotoViewGallery.builder(
              pageController: _pages,
              itemCount: _images.length,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              onPageChanged: (i) => setState(() => _index = i),
              loadingBuilder: (_, _) =>
                  const Center(child: CircularProgressIndicator()),
              builder: (context, i) => PhotoViewGalleryPageOptions(
                imageProvider: ref.read(networkImageProvider)(_images[i].url),
                minScale: PhotoViewComputedScale.contained,
                onTapUp: (_, _, _) => _toggleChrome(),
                errorBuilder: (_, _, _) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _chrome ? 1 : 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: GalleryCounter(
                        index: _index,
                        total: _images.length,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

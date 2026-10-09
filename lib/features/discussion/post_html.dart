// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../app/appearance.dart';
import '../../core/network_image.dart';
import 'cached_widget_factory.dart';
import 'reply_link_chip.dart';

class PostHtml extends ConsumerWidget {
  const PostHtml(
    this.html,
    this.appearance, {
    super.key,
    this.onLink,
    this.onImage,
  });

  final String html;
  final Appearance appearance;
  final void Function(String url)? onLink;
  final void Function(String url)? onImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) => HtmlWidget(
    html,
    baseUrl: Uri.parse('https://nyx.cz/'),
    factoryBuilder: () => CachedWidgetFactory(ref.read(networkImageProvider)),
    textStyle: TextStyle(
      fontSize: appearance.fontSize,
      color: appearance.textColor,
    ),
    customWidgetBuilder: (e) {
      if (e.localName != 'a' || !e.classes.contains('r')) return null;
      final href = e.attributes['href'];
      return InlineCustomWidget(
        child: ReplyLinkChip(
          label: e.text.trim(),
          onTap: href == null
              ? null
              : () => onLink?.call(
                  Uri.parse('https://nyx.cz/').resolve(href).toString(),
                ),
        ),
      );
    },
    customStylesBuilder: (e) => e.localName == 'a'
        ? {
            'color':
                '#${(appearance.linkColor.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}',
          }
        : null,
    onTapUrl: (url) {
      onLink?.call(url);
      return true;
    },
    onTapImage: (data) {
      final url = data.sources.isEmpty ? null : data.sources.first.url;
      if (url != null) onImage?.call(url);
    },
  );
}

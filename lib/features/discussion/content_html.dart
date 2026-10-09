// author: juraj.suchan@gmail.com

import 'dart:convert';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

final _videoTag = RegExp(
  r'<video\b[^>]*>.*?</video>',
  caseSensitive: false,
  dotAll: true,
);
final _srcAttr = RegExp(
  r'''\bsrc\s*=\s*['"]?([^'"\s>]+)''',
  caseSensitive: false,
);
final _spoiler = RegExp(r'.*"spoiler"', caseSensitive: false);

String replaceVideoTags(String source) =>
    source.replaceAllMapped(_videoTag, (m) {
      final src = _srcAttr.firstMatch(m.group(0)!)?.group(1);
      if (src == null || src.isEmpty) return '[video]';
      return '<a href="${src.replaceAll('"', '%22')}">[video]</a>';
    });

bool hasSpoiler(String content) => _spoiler.hasMatch(content);

String youtubeFix(String content) {
  if (!content.contains('youtube.com') && !content.contains('youtu.be')) {
    return content;
  }

  final body = html_parser.parse(content).body;
  if (body == null) return content;

  final out = StringBuffer();
  for (final node in body.nodes) {
    if (node is dom.Element) {
      final name = node.localName ?? '';
      final cls = node.attributes['class'];
      if (name == 'b' || name == 'br') {
        out.write(node.outerHtml);
      } else if (name == 'a' && (cls == 'extlink' || cls == 'r')) {
        out.write(node.outerHtml);
      } else if (name == 'div' && cls == 'embed-wrapper') {
        for (final child in node.children) {
          if (child.localName == 'img' &&
              child.attributes.containsKey('src') &&
              child.attributes.containsKey('data-thumb')) {
            out.write(child.outerHtml);
          }
        }
      }
    } else if (node is dom.Text) {
      out.write(const HtmlEscape(HtmlEscapeMode.element).convert(node.text));
    }
  }
  return out.toString();
}

String prepareContent(String content) => replaceVideoTags(youtubeFix(content));

final _anyTag = RegExp(r'<.*?>');

String stripHtmlTags(String html) => html.replaceAll(_anyTag, '');

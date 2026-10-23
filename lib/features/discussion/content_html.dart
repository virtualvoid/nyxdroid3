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

final _whitespace = RegExp(r'\s+');
final _blankLines = RegExp(r'\n{3,}');

const _blockTags = {'p', 'div', 'blockquote', 'li', 'ul', 'ol', 'pre'};

String htmlToPlainText(String source) {
  final out = StringBuffer();

  void newline() {
    final text = out.toString();
    if (text.isNotEmpty && !text.endsWith('\n')) out.write('\n');
  }

  void walk(dom.Node node) {
    if (node is dom.Text) {
      out.write(node.text.replaceAll(_whitespace, ' '));
      return;
    }
    if (node is! dom.Element) return;
    final name = node.localName ?? '';
    if (name == 'br') {
      out.write('\n');
      return;
    }
    if (name == 'a') {
      final href = node.attributes['href'];
      final text = node.text.trim();
      final truncated = text.endsWith('\u2026') || text.endsWith('...');
      final isReply = node.classes.contains('r');
      if (!isReply && truncated && href != null && href.startsWith('http')) {
        out.write(href);
      } else {
        out.write(text);
      }
      return;
    }
    final block = _blockTags.contains(name);
    if (block) newline();
    for (final child in node.nodes) {
      walk(child);
    }
    if (block) newline();
  }

  for (final node in html_parser.parseFragment(source).nodes) {
    walk(node);
  }
  return out
      .toString()
      .split('\n')
      .map((line) => line.trim())
      .join('\n')
      .replaceAll(_blankLines, '\n\n')
      .trim();
}

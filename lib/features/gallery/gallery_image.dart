// author: juraj.suchan@gmail.com

import 'package:html/parser.dart' as html_parser;

import '../../core/models/writeup.dart';

class GalleryImage {
  const GalleryImage({
    required this.url,
    required this.thumbUrl,
    this.writeupId = 0,
    this.nick = '',
    this.time,
    this.rating = 0,
    this.unread = false,
  });

  final String url;
  final String thumbUrl;
  final int writeupId;
  final String nick;
  final DateTime? time;
  final int rating;
  final bool unread;
}

List<GalleryImage> imagesOf(Writeup wu) {
  final result = <GalleryImage>[];
  for (final img in html_parser.parse(wu.content).getElementsByTagName('img')) {
    final src = img.attributes['src'] ?? '';
    if (src.isEmpty) continue;
    try {
      final url = Uri.decodeQueryComponent(src);
      final thumb = Uri.decodeQueryComponent(
        img.attributes['data-thumb'] ?? '',
      );
      result.add(
        GalleryImage(
          url: url,
          thumbUrl: thumb.isEmpty ? url : thumb,
          writeupId: wu.id,
          nick: wu.nick,
          time: wu.time,
          rating: wu.rating,
          unread: wu.unread,
        ),
      );
    } catch (_) {
      continue;
    }
  }
  return result;
}

typedef GallerySelection = ({List<GalleryImage> images, int startIndex});

GallerySelection? buildGallery(
  List<Writeup> writeups, {
  int? startWriteupId,
  String? startUrl,
}) {
  final images = <GalleryImage>[];
  Writeup? startWriteup;
  var startPosition = 0;
  var startUrlFound = startUrl == null;

  for (final wu in writeups) {
    if (startWriteupId != null && wu.id == startWriteupId) {
      startWriteup = wu;
      startPosition = images.length;
    }

    final own = imagesOf(wu);
    if (startUrl != null &&
        (startWriteupId == null || wu.id == startWriteupId)) {
      if (own.any((i) => i.url.toLowerCase() == startUrl.toLowerCase())) {
        startUrlFound = true;
      }
    }
    images.addAll(own);
  }

  if (!startUrlFound) {
    images.insert(
      startPosition,
      GalleryImage(
        url: startUrl!,
        thumbUrl: startUrl,
        writeupId: startWriteupId ?? 0,
        nick: startWriteup?.nick ?? '',
        time: startWriteup?.time,
        rating: startWriteup?.rating ?? 0,
        unread: startWriteup?.unread ?? false,
      ),
    );
  }

  if (images.isEmpty) return null;
  var startIndex = galleryStartIndex(
    images,
    writeupId: startWriteupId,
    url: startUrl,
  );
  final hasOwn =
      startWriteupId != null &&
      images.any((i) => i.writeupId == startWriteupId);
  if (startWriteup != null && !hasOwn && startUrl == null) {
    startIndex = startPosition.clamp(0, images.length - 1);
  }
  return (images: images, startIndex: startIndex);
}

int galleryStartIndex(
  List<GalleryImage> images, {
  int? writeupId,
  String? url,
}) {
  var position = 0;
  if (writeupId != null) {
    final i = images.indexWhere((e) => e.writeupId == writeupId);
    if (i != -1) position = i;
  }
  if (url != null) {
    for (var i = position; i < images.length; i++) {
      if (images[i].url.toLowerCase() == url.toLowerCase()) return i;
    }
  }
  return position;
}

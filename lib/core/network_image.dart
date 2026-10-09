// author: juraj.suchan@gmail.com

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'image_cache.dart';

typedef ImageProviderBuilder = ImageProvider Function(String url);

final networkImageProvider = Provider<ImageProviderBuilder>((ref) {
  final cache = ref.watch(imageCacheManagerProvider);
  return (url) => CachedNetworkImageProvider(url, cacheManager: cache);
});

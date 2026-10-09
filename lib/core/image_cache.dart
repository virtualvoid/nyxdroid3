// author: juraj.suchan@gmail.com

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nyxCacheManager = CacheManager(
  Config(
    'nyxImages',
    stalePeriod: const Duration(days: 30),
    maxNrOfCacheObjects: 1024,
  ),
);

Future<void> clearImageCache() => nyxCacheManager.emptyCache();

final imageCacheManagerProvider = Provider<BaseCacheManager>(
  (ref) => nyxCacheManager,
);

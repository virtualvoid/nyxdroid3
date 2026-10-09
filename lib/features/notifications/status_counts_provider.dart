// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/status_counts.dart';
import '../../core/providers.dart';

final statusCountsProvider = FutureProvider.autoDispose<StatusCounts>(
  (ref) => ref.watch(mailRepositoryProvider).getStatus(),
);

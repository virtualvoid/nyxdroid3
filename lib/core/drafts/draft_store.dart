// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sqlite_draft_store.dart';

abstract class DraftStore {
  Future<String?> load(String key);
  Future<void> save(String key, String text);
  Future<void> delete(String key);
}

final draftStoreProvider = Provider<DraftStore>((ref) => SqliteDraftStore());

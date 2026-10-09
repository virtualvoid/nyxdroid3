// author: juraj.suchan@gmail.com

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../core/drafts/draft_store.dart';

class DraftSaver {
  DraftSaver({
    required this.store,
    required this.key,
    required this.controller,
    this.delay = const Duration(milliseconds: 600),
  }) {
    controller.addListener(_onChanged);
  }

  final DraftStore store;
  final String key;
  final TextEditingController controller;
  final Duration delay;

  Timer? _timer;
  String _lastSaved = '';
  bool _disposed = false;
  bool _cleared = false;

  Future<bool> restore() async {
    String? draft;
    try {
      draft = await store.load(key);
    } catch (_) {
      return false;
    }
    if (_disposed || draft == null || draft.isEmpty) return false;
    if (controller.text.isNotEmpty) return false;
    _lastSaved = draft;
    controller.value = TextEditingValue(
      text: draft,
      selection: TextSelection.collapsed(offset: draft.length),
    );
    return true;
  }

  void _onChanged() {
    if (_disposed || _cleared) return;
    if (controller.text == _lastSaved) return;
    _timer?.cancel();
    _timer = Timer(delay, _persist);
  }

  Future<void> _persist() async {
    _timer = null;
    final text = controller.text;
    if (text == _lastSaved) return;
    _lastSaved = text;
    try {
      if (text.trim().isEmpty) {
        await store.delete(key);
      } else {
        await store.save(key, text);
      }
    } catch (_) {}
  }

  Future<void> discard() async {
    _timer?.cancel();
    _timer = null;
    _lastSaved = '';
    controller.clear();
    try {
      await store.delete(key);
    } catch (_) {}
  }

  Future<void> clear() async {
    _cleared = true;
    _timer?.cancel();
    _timer = null;
    _lastSaved = '';
    try {
      await store.delete(key);
    } catch (_) {}
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    controller.removeListener(_onChanged);
    final pending = _timer != null;
    _timer?.cancel();
    _timer = null;
    if (pending && !_cleared) _persistFinal();
  }

  void _persistFinal() {
    final text = controller.text;
    if (text == _lastSaved) return;
    final result = text.trim().isEmpty
        ? store.delete(key)
        : store.save(key, text);
    unawaited(result.catchError((_) {}));
  }
}

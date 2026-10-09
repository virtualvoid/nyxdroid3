// author: juraj.suchan@gmail.com

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/writeup.dart';
import 'gallery_grid_controller.dart';
import 'gallery_image.dart';

class GalleryGridState {
  const GalleryGridState({
    this.name = '',
    this.images = const [],
    this.writeups = const {},
    this.lastWriteupId,
    this.loading = false,
    this.reachedEnd = false,
    this.error,
  });

  final String name;
  final List<GalleryImage> images;
  final Map<int, Writeup> writeups;
  final int? lastWriteupId;
  final bool loading;
  final bool reachedEnd;
  final Object? error;

  GalleryGridState copyWith({
    String? name,
    List<GalleryImage>? images,
    Map<int, Writeup>? writeups,
    int? lastWriteupId,
    bool? loading,
    bool? reachedEnd,
    Object? error,
    bool clearError = false,
  }) => GalleryGridState(
    name: name ?? this.name,
    images: images ?? this.images,
    writeups: writeups ?? this.writeups,
    lastWriteupId: lastWriteupId ?? this.lastWriteupId,
    loading: loading ?? this.loading,
    reachedEnd: reachedEnd ?? this.reachedEnd,
    error: clearError ? null : (error ?? this.error),
  );
}

final galleryGridControllerProvider = NotifierProvider.autoDispose
    .family<GalleryGridController, GalleryGridState, int>(
      GalleryGridController.new,
    );

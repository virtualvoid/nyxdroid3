// author: juraj.suchan@gmail.com

import 'gallery_image.dart';

class GalleryArgs {
  const GalleryArgs(this.images, {this.startIndex = 0});

  final List<GalleryImage> images;
  final int startIndex;
}

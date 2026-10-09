// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class GalleryCounter extends StatelessWidget {
  const GalleryCounter({super.key, required this.index, required this.total});

  final int index;
  final int total;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      '${index + 1} / $total',
      key: const Key('gallery_counter'),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    ),
  );
}

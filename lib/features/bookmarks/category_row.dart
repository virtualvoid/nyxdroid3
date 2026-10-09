// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/appearance.dart';
import '../../core/models/bookmark_category.dart';
import 'row_frame.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.category,
    required this.appearance,
    this.expanded,
    this.onTap,
  });

  final BookmarkCategory category;
  final Appearance appearance;
  final bool? expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: RowFrame(
        appearance: appearance,
        background: scheme.surfaceContainerHigh,
        child: Row(
          children: [
            Expanded(
              child: Text(
                category.name.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: appearance.fontSize - 1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: scheme.primary,
                ),
              ),
            ),
            if (expanded != null)
              AnimatedRotation(
                key: Key('category_chevron_${category.id}'),
                turns: expanded! ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.expand_more,
                  size: appearance.compact ? 20 : 24,
                  color: scheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

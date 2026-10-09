// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

typedef ReplyChipData = ({String id, String label});

class ReplyChips extends StatelessWidget {
  const ReplyChips({super.key, required this.items, required this.onRemove});

  final List<ReplyChipData> items;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final item in items)
                InputChip(
                  key: Key('reply_chip_${item.id}'),
                  avatar: Icon(Icons.reply, size: 18, color: scheme.primary),
                  label: Text(item.label),
                  onDeleted: () => onRemove(item.id),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

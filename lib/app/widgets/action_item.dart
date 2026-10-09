// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class ActionItem<T extends Enum> {
  const ActionItem(this.value, this.icon, this.label, {this.trailing});

  final T value;
  final IconData icon;
  final String label;
  final Widget? trailing;
}

Future<T?> showActionSheet<T extends Enum>(
  BuildContext context,
  List<ActionItem<T>> items,
) => showModalBottomSheet<T>(
  context: context,
  showDragHandle: true,
  builder: (sheetContext) {
    final scheme = Theme.of(sheetContext).colorScheme;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in items)
              ListTile(
                key: Key('action_${item.value.name}'),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: scheme.secondaryContainer,
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: scheme.onSecondaryContainer,
                  ),
                ),
                title: Text(item.label),
                trailing: item.trailing,
                onTap: () => Navigator.pop(sheetContext, item.value),
              ),
          ],
        ),
      ),
    );
  },
);

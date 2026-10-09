// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import 'choice_option.dart';
import '../../app/widgets/tonal_icon.dart';

class ChoiceSetting<T> extends StatelessWidget {
  const ChoiceSetting({
    super.key,
    required this.icon,
    required this.title,
    required this.summary,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String summary;
  final List<ChoiceOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  Future<void> _pick(BuildContext context) async {
    final picked = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(
                  title,
                  key: const Key('choice_sheet_title'),
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: RadioGroup<T>(
                    groupValue: value,
                    onChanged: (v) => Navigator.pop(sheetContext, v),
                    child: Column(
                      children: [
                        for (final o in options)
                          RadioListTile<T>(
                            key: Key('choice_${o.value}'),
                            title: Text(o.label),
                            value: o.value,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final current = options.where((o) => o.value == value).firstOrNull;

    return ListTile(
      leading: TonalIcon(icon),
      title: Text(title),
      subtitle: Text(summary),
      trailing: current == null
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                current.label,
                key: const Key('choice_current'),
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      onTap: () => _pick(context),
    );
  }
}

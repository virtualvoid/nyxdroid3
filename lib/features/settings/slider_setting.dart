// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/widgets/tonal_icon.dart';

class SliderSetting extends StatelessWidget {
  const SliderSetting({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: TonalIcon(icon),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Slider(
            key: const Key('slider_setting'),
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: (max - min).round(),
            label: value.round().toString(),
            onChanged: onChanged,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              'Aa',
              key: const Key('slider_preview'),
              style: TextStyle(fontSize: value, color: scheme.onSurface),
            ),
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value.round().toString(),
          key: const Key('slider_value'),
          style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

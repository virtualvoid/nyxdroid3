// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

import '../../app/widgets/tonal_icon.dart';

class SwitchSetting extends StatelessWidget {
  const SwitchSetting({
    super.key,
    required this.icon,
    required this.title,
    required this.summaryOn,
    required this.summaryOff,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String summaryOn;
  final String summaryOff;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    secondary: TonalIcon(icon),
    title: Text(title),
    subtitle: Text(value ? summaryOn : summaryOff),
    value: value,
    onChanged: onChanged,
  );
}

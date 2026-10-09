// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class TonalIcon extends StatelessWidget {
  const TonalIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: 20,
      backgroundColor: scheme.secondaryContainer,
      child: Icon(icon, size: 20, color: scheme.onSecondaryContainer),
    );
  }
}

// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class HistorySwipeBackground extends StatelessWidget {
  const HistorySwipeBackground({
    super.key,
    required this.icon,
    required this.alignment,
    required this.color,
    required this.iconColor,
  });

  final IconData icon;
  final Alignment alignment;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Container(
    color: color,
    alignment: alignment,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Icon(icon, color: iconColor),
  );
}

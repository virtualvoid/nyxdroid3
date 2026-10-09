// author: juraj.suchan@gmail.com

import 'package:flutter/material.dart';

class DrawerEntry {
  const DrawerEntry(this.route, this.icon, this.title, {this.badge = 0});

  final String route;
  final IconData icon;
  final String title;
  final int badge;
}

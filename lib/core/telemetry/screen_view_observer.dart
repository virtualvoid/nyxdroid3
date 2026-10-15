// author: juraj.suchan@gmail.com

import 'package:flutter/widgets.dart';

String? screenNameOf(String? routeName) {
  if (routeName == null) return null;
  final path = routeName.split('?').first;
  for (final segment in path.split('/')) {
    if (segment.isNotEmpty) return segment;
  }
  return null;
}

class ScreenViewObserver extends NavigatorObserver {
  ScreenViewObserver(this._onScreen);

  final void Function(String name) _onScreen;

  void _report(Route<dynamic>? route) {
    if (route is! PageRoute) return;
    final name = screenNameOf(route.settings.name);
    if (name != null) _onScreen(name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _report(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _report(newRoute);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _report(previousRoute);
}

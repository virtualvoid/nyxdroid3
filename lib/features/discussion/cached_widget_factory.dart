// author: juraj.suchan@gmail.com

import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../core/network_image.dart';

class CachedWidgetFactory extends WidgetFactory {
  CachedWidgetFactory(this._build);

  final ImageProviderBuilder _build;

  @override
  ImageProvider? imageProviderFromNetwork(String url) => _build(url);
}

// author: juraj.suchan@gmail.com

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PositionedListScrollbar extends StatefulWidget {
  const PositionedListScrollbar({
    super.key,
    required this.positions,
    required this.controller,
    required this.itemCount,
    required this.child,
  });

  final ItemPositionsListener positions;
  final ItemScrollController controller;
  final int itemCount;
  final Widget child;

  @override
  State<PositionedListScrollbar> createState() =>
      _PositionedListScrollbarState();
}

class _PositionedListScrollbarState extends State<PositionedListScrollbar> {
  static const _minThumb = 48.0;
  static const _hideAfter = Duration(milliseconds: 1200);

  double _top = 0;
  double _size = 1;
  bool _visible = false;
  bool _dragging = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    widget.positions.itemPositions.addListener(_update);
  }

  @override
  void dispose() {
    widget.positions.itemPositions.removeListener(_update);
    _hideTimer?.cancel();
    super.dispose();
  }

  void _update() {
    final items = widget.positions.itemPositions.value;
    final count = widget.itemCount;
    if (items.isEmpty || count == 0) return;
    var first = items.first;
    var last = items.first;
    for (final p in items) {
      if (p.index < first.index) first = p;
      if (p.index > last.index) last = p;
    }
    final firstExtent = first.itemTrailingEdge - first.itemLeadingEdge;
    final lastExtent = last.itemTrailingEdge - last.itemLeadingEdge;
    final hiddenTop = firstExtent > 0
        ? (-first.itemLeadingEdge / firstExtent).clamp(0.0, 1.0)
        : 0.0;
    final hiddenBottom = lastExtent > 0
        ? ((last.itemTrailingEdge - 1) / lastExtent).clamp(0.0, 1.0)
        : 0.0;
    final span = (last.index + 1 - first.index) - hiddenTop - hiddenBottom;
    final size = (span / count).clamp(0.0, 1.0);
    final top = ((first.index + hiddenTop) / count).clamp(0.0, 1.0 - size);
    _hideTimer?.cancel();
    if (!_dragging) _hideTimer = Timer(_hideAfter, _hide);
    setState(() {
      _size = size;
      _top = top;
      _visible = size < 1;
    });
  }

  void _hide() {
    if (mounted && !_dragging) setState(() => _visible = false);
  }

  void _dragTo(double globalY, double thumb, double track) {
    final box = context.findRenderObject() as RenderBox;
    final y = box.globalToLocal(Offset(0, globalY)).dy;
    final p = track <= 0 ? 0.0 : ((y - thumb / 2) / track).clamp(0.0, 1.0);
    final index = (p * (widget.itemCount - 1)).round();
    if (widget.controller.isAttached) {
      widget.controller.jumpTo(index: index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final thumb = math
                  .max(_size * height, _minThumb)
                  .clamp(0.0, height);
              final track = height - thumb;
              final travel = 1 - _size;
              final progress = travel <= 0
                  ? 0.0
                  : (_top / travel).clamp(0.0, 1.0);
              return Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: progress * track,
                    width: 28,
                    height: thumb,
                    child: IgnorePointer(
                      ignoring: !_visible,
                      child: GestureDetector(
                        key: const Key('positioned_scrollbar_thumb'),
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragStart: (_) {
                          _hideTimer?.cancel();
                          setState(() => _dragging = true);
                        },
                        onVerticalDragUpdate: (d) =>
                            _dragTo(d.globalPosition.dy, thumb, track),
                        onVerticalDragEnd: (_) {
                          _dragging = false;
                          _hideTimer = Timer(_hideAfter, _hide);
                          setState(() {});
                        },
                        child: AnimatedOpacity(
                          opacity: _visible ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: _dragging ? 10 : 6,
                              margin: const EdgeInsets.only(right: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(
                                  alpha: _dragging ? 0.9 : 0.6,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

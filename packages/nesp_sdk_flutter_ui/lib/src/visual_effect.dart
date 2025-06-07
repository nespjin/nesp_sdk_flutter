import 'package:flutter/material.dart';

class VisualEffect extends StatefulWidget {
  const VisualEffect({
    super.key,
    required this.enabled,
    required this.canTap,
    this.onTap,
    required this.child,
  });

  final bool enabled;
  final bool canTap;
  final VoidCallback? onTap;
  final Widget child;

  @override
  State<VisualEffect> createState() => _VisualEffectState();
}

class _VisualEffectState extends State<VisualEffect> {
  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || (widget.canTap && widget.onTap == null)) {
      _opacity = 0.7;
    }
    final child = Opacity(opacity: _opacity, child: widget.child);
    if (!widget.canTap) return child;
    return GestureDetector(
      onTap: !widget.enabled ? null : widget.onTap,
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _effectOpacity(),
      onTapUp: (_) => _resetOpacity(),
      onVerticalDragDown: (_) => _effectOpacity(),
      onVerticalDragEnd: (_) => _resetOpacity(),
      onHorizontalDragDown: (_) => _effectOpacity(),
      onHorizontalDragEnd: (_) => _resetOpacity(),
      child: child,
    );
  }

  void _effectOpacity() {
    setState(() => _opacity = 0.7);
  }

  void _resetOpacity() {
    setState(() => _opacity = 1);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The widget is never rebuilt, only used to use S behavior,
/// not to access the state of S.
class NeverRebuildSelector<S> extends StatelessWidget {
  const NeverRebuildSelector({
    super.key,
    required this.builder,
    this.child,
  });

  final ValueWidgetBuilder<S> builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Selector<S, S>(
      selector: (_, s) => s,
      shouldRebuild: (_, __) => false,
      builder: builder,
      child: child,
    );
  }
}

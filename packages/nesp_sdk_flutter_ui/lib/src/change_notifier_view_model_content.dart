import 'package:flutter/material.dart';
import 'package:nesp_sdk_flutter_core/nesp_sdk_flutter_core.dart';
import 'package:nesp_sdk_flutter_ui/src/view_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChangeNotifierViewModelContent<VM extends ChangeNotifierViewModel>
    extends StatelessWidget {
  const ChangeNotifierViewModelContent({
    super.key,
    required this.create,
    this.builder,
  });

  final Create<VM> create;
  final TransitionBuilder? builder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VM>(
      create: create,
      builder: (context, child) {
        return VisibilityDetector(
          key: ValueKey(hashCode),
          onVisibilityChanged: context.read<VM>().onVisibilityChanged,
          child:
              builder?.call(context, child) ?? child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

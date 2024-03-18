import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class FadePageGoRouteData extends GoRouteData {
  FadePageGoRouteData({
    this.childBuilder,
    this.screenBuilder,
    this.redirect2,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
  }) : assert(
            screenBuilder != null || childBuilder != null || redirect2 != null,
            'builder, pageBuilder, or redirect must be provided');

  final GoRouterPageBuilder? screenBuilder;
  final GoRouterWidgetBuilder? childBuilder;
  final GoRouterRedirect? redirect2;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final bool maintainState;
  final bool fullscreenDialog;
  final bool opaque;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (screenBuilder != null) {
      return screenBuilder!(context, state);
    }
    return CustomTransitionPage(
      child: childBuilder!(context, state),
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      opaque: opaque,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

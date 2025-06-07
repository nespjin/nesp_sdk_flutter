import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class FadePageGoRoute extends GoRoute {
  FadePageGoRoute({
    required super.path,
    super.name,
    this.childBuilder,
    this.screenBuilder,
    super.parentNavigatorKey,
    super.redirect,
    super.routes = const <RouteBase>[],
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
  })  : assert(
            screenBuilder != null || childBuilder != null || redirect != null,
            'builder, pageBuilder, or redirect must be provided'),
        super(pageBuilder: (BuildContext context, GoRouterState state) {
          if (screenBuilder != null) {
            return screenBuilder(context, state);
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
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        });

  final GoRouterPageBuilder? screenBuilder;
  final GoRouterWidgetBuilder? childBuilder;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final bool maintainState;
  final bool fullscreenDialog;
  final bool opaque;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
}

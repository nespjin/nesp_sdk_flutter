// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class CupertinoPageGoRoute extends GoRoute {
  CupertinoPageGoRoute({
    required super.path,
    super.name,
    this.childBuilder,
    this.screenBuilder,
    super.parentNavigatorKey,
    super.redirect,
    super.routes = const <RouteBase>[],
  })  : assert(
            screenBuilder != null || childBuilder != null || redirect != null,
            'builder, pageBuilder, or redirect must be provided'),
        super(pageBuilder: (BuildContext context, GoRouterState state) {
          if (screenBuilder != null) {
            return screenBuilder(context, state);
          }
          return CupertinoPage(child: childBuilder!(context, state));
        });

  final GoRouterPageBuilder? screenBuilder;
  final GoRouterWidgetBuilder? childBuilder;
}

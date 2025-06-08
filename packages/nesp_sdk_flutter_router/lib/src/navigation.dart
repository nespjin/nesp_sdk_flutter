// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:nesp_sdk_dart_dtx/nesp_sdk_dart_dtx.dart';

class RouteStack with ChangeNotifier {
  final List<Route> stack = [];

  Route? firstNullableWhere(bool Function(Route) predicate) {
    return stack.firstNullableWhere(predicate);
  }

  bool isActive(String name) {
    return firstNullableWhere((route) => route.settings.name == name)
            ?.isActive ??
        false;
  }

  bool hasRoute(RoutePredicate predicate) {
    return stack.any(predicate);
  }

  bool hasActiveRoute(RoutePredicate predicate) {
    return stack.any((element) => predicate(element) && element.isActive);
  }

  void pop<T>(RoutePredicate predicate, [T? result]) {
    final list = List.of(stack.where(predicate));
    for (final route in list) {
      route.didPop(result);
      route.navigator?.removeRoute(route);
    }
  }

  /// 实现跨Navigator
  void popUntil(RoutePredicate predicate,
      {dynamic Function(Route)? popResult}) {
    while (stack.isNotEmpty && !predicate(stack.last)) {
      stack.last.navigator?.pop(popResult?.call(stack.last));
    }
  }

  void checkDispose() {
    final list = List.of(stack.where((element) => !element.isActive));
    for (final element in list) {
      stack.remove(element);
    }
  }

  void add(Route route) {
    stack.add(route);
    notifyListeners();
  }

  void remove(Route route) {
    stack.remove(route);
    notifyListeners();
  }
}

class RouteRecorder extends NavigatorObserver {
  RouteRecorder(this.stack);

  final RouteStack stack;

  @override
  void didPush(Route route, Route? previousRoute) {
    stack.add(route);
    stack.checkDispose();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      stack.remove(oldRoute);
    }

    if (newRoute != null) {
      stack.add(newRoute);
    }

    stack.checkDispose();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    stack.remove(route);
    stack.checkDispose();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    stack.remove(route);
    stack.checkDispose();
  }
}

// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nesp_sdk_flutter_router/nesp_sdk_flutter_router.dart';

abstract base class Module {
  const Module({
    required this.id,
  });

  final String id;

  FutureOr<void> onInit() async {}

  FutureOr<void> onLocaleChanged(BuildContext context, Locale locale) async {}

  FutureOr<void> onLocalesChanged(
      BuildContext context, List<Locale> locales) async {}

  void onUpdateLocalizationsDelegates(
      List<LocalizationsDelegate> delegates) async {
    final List<LocalizationsDelegate> newLocalizationsDelegates = [
      ...getLocalizationsDelegates(),
      ...delegates,
    ];
    delegates.clear();
    delegates.addAll(newLocalizationsDelegates);
  }

  List<LocalizationsDelegate> getLocalizationsDelegates() {
    return [];
  }

  FutureOr<void> onUpdateRoutes(
      BuildContext context, List<RouteBase> routes) async {}
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nesp_sdk_flutter_router/nesp_sdk_flutter_router.dart';

abstract base class Module {
  const Module({
    required this.id,
  });

  final String id;

  FutureOr<void> onInit() async {}

  FutureOr<void> onLocaleChanged(Locale locale) async {}

  FutureOr<void> onLocalesChanged(List<Locale> locales) async {}

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

  FutureOr<void> onUpdateRoutes(List<RouteBase> routes) async {}
}

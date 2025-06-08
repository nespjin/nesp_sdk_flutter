// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nesp_sdk_flutter_module/src/module.dart';
import 'package:nesp_sdk_flutter_router/nesp_sdk_flutter_router.dart';

final class ModuleManager {
  static ModuleManager? _instance;

  ModuleManager._();

  static ModuleManager get shared => _instance ??= ModuleManager._();

  /// Stores all modules that registered.
  final _store = <String /*Module Id*/, Module>{};

  /// Registers a [module].
  void registerModule(Module module) {
    _store[module.id] = module;
  }

  /// Unregisters a [module].
  void unregisterModule(Module module) {
    _store.remove(module.id);
  }

  /// Gets the module with the given [id].
  /// Returns `null` if the module is not registered.
  Module? getModule(String id) => _store[id];

  FutureOr<void> updateRoutes(
      BuildContext context, List<RouteBase> routes) async {
    for (var module in _store.values) {
      await module.onUpdateRoutes(context, routes);
    }
  }

  /// Whether the module with the given [id] is registered.
  bool isModuleRegistered(String id) => getModule(id) != null;

  /// Initializes all modules that registered.
  FutureOr<void> initModules() async {
    for (var module in _store.values) {
      await module.onInit();
    }
  }

  FutureOr<void> changeLocale(BuildContext context, Locale locale) async {
    for (var module in _store.values) {
      await module.onLocaleChanged(context, locale);
    }
  }

  /// Called when the application locales is changed.
  FutureOr<void> changeLocales(
      BuildContext context, List<Locale> locales) async {
    for (var module in _store.values) {
      await module.onLocalesChanged(context, locales);
    }
  }

  void updateLocalizationsDelegates(
      List<LocalizationsDelegate> localizationsDelegates) {
    for (var module in _store.values) {
      module.onUpdateLocalizationsDelegates(localizationsDelegates);
    }
  }
}

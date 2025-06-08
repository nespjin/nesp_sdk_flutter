// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nesp_sdk_flutter_core/nesp_sdk_flutter_core.dart';
import 'package:nesp_sdk_flutter_module/nesp_sdk_flutter_module.dart';
import 'package:nesp_sdk_flutter_router/nesp_sdk_flutter_router.dart';

typedef ShellScreenBuilder = Widget Function(
    BuildContext context, GoRouterState state, Widget child);

GoRouter? _goRouter;

/// This widget is the root of whole application.
class Application extends StatelessWidget {
  const Application({
    super.key,
    this.isUseCupertino = false,
    this.title = '',
    this.rootNavigatorKey,
    this.shellNavigatorKey,
    this.cupertinoTheme,
    this.theme,
    this.darkTheme,
    this.themeMode,
    // this.routes = const <String, WidgetBuilder>{},
    this.routes = const [],
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.locale,
    this.localizationsDelegates,
    this.localeResolutionCallback,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.shellScreenBuilder,
    this.onGenerateTitle,
    this.initialLocation = '/',
    this.moduleManager,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.backButtonDispatcher,
    this.errorPageBuilder,
    this.errorBuilder,
    this.redirect,
    this.refreshListenable,
    this.redirectLimit = 5,
    this.initialExtra,
    this.restorationScopeId,
  });

  static RouteStack routeStack = RouteStack();
  static RouteRecorder routeRecorder = RouteRecorder(routeStack);

  final bool isUseCupertino;
  final String title;
  final GlobalKey<NavigatorState>? rootNavigatorKey;
  final GlobalKey<NavigatorState>? shellNavigatorKey;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Locale? locale;
  final LocaleResolutionCallback? localeResolutionCallback;
  final List<NavigatorObserver> navigatorObservers;
  final ThemeData? theme;
  final CupertinoThemeData? cupertinoTheme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;

  // final Map<String, WidgetBuilder> routes;
  final List<RouteBase> routes;
  final TransitionBuilder? builder;
  final ShellScreenBuilder? shellScreenBuilder;
  final GenerateAppTitle? onGenerateTitle;
  final String initialLocation;
  final ModuleManager? moduleManager;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;
  final GoRouterPageBuilder? errorPageBuilder;
  final GoRouterWidgetBuilder? errorBuilder;
  final GoRouterRedirect? redirect;
  final Listenable? refreshListenable;
  final int redirectLimit;
  final Object? initialExtra;
  final String? restorationScopeId;

  @override
  Widget build(BuildContext context) {
    final appLocalizationsDelegates = [
      ...(localizationsDelegates ?? <LocalizationsDelegate<dynamic>>[])
    ];
    // appLocalizationsDelegates.addAll(Strings.localizationsDelegates);

    List<RouteBase> rootRoutes = [...routes];

    List<RouteBase> childRoutes = [];

    if (moduleManager != null) {
      // Merge modules localization delegates
      moduleManager!.updateLocalizationsDelegates(appLocalizationsDelegates);

      // Merge modules routes
      if (shellScreenBuilder != null) {
        moduleManager!.updateRoutes(context, childRoutes);

        final shellRoute = ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: shellScreenBuilder,
          routes: childRoutes,
        );
        rootRoutes.add(shellRoute);
      } else {
        moduleManager!.updateRoutes(context, childRoutes);
      }
    }

    _goRouter ??= GoRouter(
      navigatorKey: rootNavigatorKey,
      errorBuilder: errorBuilder,
      errorPageBuilder: errorPageBuilder,
      redirect: redirect,
      refreshListenable: refreshListenable,
      redirectLimit: redirectLimit,
      observers: [
        ...navigatorObservers,
        routeRecorder,
      ],
      initialLocation: initialLocation,
      initialExtra: initialExtra,
      restorationScopeId: restorationScopeId,
      routes: rootRoutes,
    );
    return isUseCupertino
        ? CupertinoApp.router(
            key: key,
            title: title,
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: supportedLocales,
            localeResolutionCallback: localeResolutionCallback,
            locale: locale,
            debugShowCheckedModeBanner: false,
            onGenerateTitle: onGenerateTitle,
            theme: cupertinoTheme,
            routerConfig: _goRouter,
            routeInformationProvider: routeInformationProvider,
            routeInformationParser: routeInformationParser,
            routerDelegate: routerDelegate,
            backButtonDispatcher: backButtonDispatcher,
            builder: (context, child) {
              Widget realChild = MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child ?? const SizedBox.shrink(),
              );

              if (builder == null) {
                return realChild;
              }

              return builder!(context, realChild);
            },
          )
        : MaterialApp.router(
            key: key,
            title: title,
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: supportedLocales,
            localeResolutionCallback: localeResolutionCallback,
            locale: locale,
            debugShowCheckedModeBanner: false,
            onGenerateTitle: onGenerateTitle,
            theme: theme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            routerConfig: _goRouter,
            routeInformationProvider: routeInformationProvider,
            routeInformationParser: routeInformationParser,
            routerDelegate: routerDelegate,
            backButtonDispatcher: backButtonDispatcher,
            builder: (context, child) {
              Widget realChild = MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child ?? const SizedBox.shrink(),
              );

              if (builder == null) {
                return realChild;
              }

              return builder!(context, realChild);
            },
          );
  }
}

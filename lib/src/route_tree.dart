import 'dart:async';
import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_navigation/src/route_info.dart';

import 'observers/navigation_two_observer.dart';

typedef ExceptionHandler = void Function(
  BuildContext context,
  GoRouterState state,
  GoRouter router,
);

typedef RouteTreePageBuilder = Page Function(
  BuildContext context,
  GoRouterState state,
);

typedef RouteTreeWidgetBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
);

typedef RouteTreeRedirect = FutureOr<String?> Function(
  BuildContext context,
  GoRouterState state,
);

class RouteTree implements GoRouter {
  RouteTree({
    required List<RouteInfo> routeInfoList,
    required List<RouteBase> routes,
    Codec<Object?, Object?>? extraCodec,
    ExceptionHandler? onException,
    RouteTreePageBuilder? errorPageBuilder,
    RouteTreeWidgetBuilder? errorBuilder,
    RouteTreeRedirect? redirect,
    Listenable? refreshListenable,
    int redirectLimit = 5,
    bool routerNeglect = false,
    String? initialLocation,
    bool overridePlatformDefaultLocation = false,
    Object? initialExtra,
    List<NavigatorObserver>? observers,
    bool debugLogDiagnostics = false,
    GlobalKey<NavigatorState>? navigatorKey,
    String? restorationScopeId,
    bool requestFocus = true,
  }) {
    router = GoRouter(
      routes: routes,
      extraCodec: extraCodec,
      onException: onException,
      errorPageBuilder: errorPageBuilder,
      errorBuilder: errorBuilder,
      redirect: redirect,
      refreshListenable: refreshListenable,
      redirectLimit: redirectLimit,
      routerNeglect: routerNeglect,
      initialLocation: initialLocation,
      overridePlatformDefaultLocation: overridePlatformDefaultLocation,
      initialExtra: initialExtra,
      observers: [BotToastNavigatorObserver(), ...(observers ?? [])],
      debugLogDiagnostics: debugLogDiagnostics,
      navigatorKey: navigatorKey,
      restorationScopeId: restorationScopeId,
      requestFocus: requestFocus,
    );
    configuration = router.configuration;
    routeInformationParser = router.routeInformationParser;
    routeInformationProvider = router.routeInformationProvider;
    routerDelegate = router.routerDelegate;
  }

  late final GoRouter router;

  @override
  late final RouteConfiguration configuration;

  @override
  late final GoRouteInformationParser routeInformationParser;

  @override
  late final GoRouteInformationProvider routeInformationProvider;

  @override
  late final GoRouterDelegate routerDelegate;

  @override
  BackButtonDispatcher get backButtonDispatcher => router.backButtonDispatcher;

  @override
  bool canPop() {
    return router.canPop();
  }

  @override
  void dispose() {
    router.dispose();
  }

  @override
  void go(String location, {Object? extra}) {
    router.go(location, extra: extra);
  }

  @override
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    router.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  @override
  String namedLocation(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
  }) {
    return router.namedLocation(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }

  @override
  bool get overridePlatformDefaultLocation => router.overridePlatformDefaultLocation;

  @override
  void pop<T extends Object?>([T? result]) {
    router.pop(result);
  }

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    return router.push(location, extra: extra);
  }

  @override
  Future<T?> pushNamed<T extends Object?>(String name,
      {Map<String, String> pathParameters = const <String, String>{},
      Map<String, dynamic> queryParameters = const <String, dynamic>{},
      Object? extra}) {
    return router.pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  @override
  Future<T?> pushReplacement<T extends Object?>(String location, {Object? extra}) {
    return router.pushReplacement(location, extra: extra);
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?>(String name,
      {Map<String, String> pathParameters = const <String, String>{},
      Map<String, dynamic> queryParameters = const <String, dynamic>{},
      Object? extra}) {
    return router.pushReplacementNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  @override
  void refresh() {
    router.refresh();
  }

  @override
  Future<T?> replace<T>(String location, {Object? extra}) {
    return router.replace(location, extra: extra);
  }

  @override
  Future<T?> replaceNamed<T>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    return router.replaceNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  @override
  void restore(RouteMatchList matchList) {
    router.restore(matchList);
  }

  @override
  GoRouterState? get state => router.state;
}

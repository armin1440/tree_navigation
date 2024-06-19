import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../tree_navigation.dart';
import 'my_navigation_observer.dart';
import 'package:get_it/get_it.dart';

typedef RouteTreeDefaultPageBuilder = Page Function(
    BuildContext context,
    GoRouterState state,
    Widget widget,
    );
typedef RouteTreeDefaultShellPageBuilder = Page Function(
    BuildContext context,
    GoRouterState state,
    Widget widget,
    Widget childWidget,
    );

abstract class TreeNavigation {

  ///The keys specified in navigatorKeyList has to be in order.
  ///The first key has to be the top most key. Other ones has to be lower level keys and they also has to be in order.
  ///example:
  ///if the route tree looks like this:
  ///
  /// navigatorKey = topKey,
  ///routes = [
  ///   TreeShellRoute(
  ///     key: shellKey,
  ///    routes: [...],
  ///   )
  /// ],
  ///
  ///Then the navigatorKeyList should be: [topKey, shellKey]
  static MaterialApp makeMaterialApp({
    //These are used in MaterialApp.router
    Key? key,
    GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
    NotificationListenerCallback<NavigationNotification>? onNavigationNotification,
    RouteInformationProvider? routeInformationProvider,
    RouteInformationParser<Object>? routeInformationParser,
    RouterDelegate<Object>? routerDelegate,
    BackButtonDispatcher? backButtonDispatcher,
    String title = '',
    GenerateAppTitle? onGenerateTitle,
    ThemeData? theme,
    ThemeData? darkTheme,
    ThemeData? highContrastTheme,
    ThemeData? highContrastDarkTheme,
    ThemeMode? themeMode = ThemeMode.system,
    Duration themeAnimationDuration = kThemeAnimationDuration,
    Curve themeAnimationCurve = Curves.linear,
    Color? color,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    LocaleListResolutionCallback? localeListResolutionCallback,
    LocaleResolutionCallback? localeResolutionCallback,
    Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')],
    bool showPerformanceOverlay = false,
    bool checkerboardOffscreenLayers = false,
    bool showSemanticsDebugger = false,
    bool debugShowCheckedModeBanner = false,
    Map<ShortcutActivator, Intent>? shortcuts,
    Map<Type, Action<Intent>>? actions,
    String? materialAppRestorationScopeId,
    ScrollBehavior? scrollBehavior,
    AnimationStyle? themeAnimationStyle,
    //These are used in GoRouter
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
    required GlobalKey<NavigatorState> navigatorKey,
    required List<GlobalKey<NavigatorState>> globalKeyList,
    String? routerRestorationScopeId,
    bool requestFocus = true,
    RouteTreeDefaultPageBuilder? defaultPageBuilder,
    RouteTreeDefaultShellPageBuilder? defaultShellPageBuilder,
  }) {
    if (defaultPageBuilder != null || defaultShellPageBuilder != null) {
      _addDefaultPageBuilderToRoutes(
        routes: routes,
        pageBuilder: defaultPageBuilder,
        shellPageBuilder: defaultShellPageBuilder,
      );
    }

    RouterConfig<Object> routerConfig = RouteTree(
      routeInfoList: routeInfoList,
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
      observers: [MyNavigationObserver(routeInfoList), ...(observers ?? [])],
      debugLogDiagnostics: debugLogDiagnostics,
      navigatorKey: navigatorKey,
      restorationScopeId: routerRestorationScopeId,
      requestFocus: requestFocus,
    );

    NavigationInterface navigationInterface = NavigationService(
      routeInfoList: routeInfoList,
      globalKeyList: globalKeyList,
    );
    GetIt.instance.registerSingleton(navigationInterface);

    return MaterialApp.router(
      key: key,
      scaffoldMessengerKey: scaffoldMessengerKey,
      onNavigationNotification: onNavigationNotification,
      routeInformationProvider: routeInformationProvider,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
      backButtonDispatcher: backButtonDispatcher,
      routerConfig: routerConfig,
      builder: BotToastInit(),
      title: title,
      onGenerateTitle: onGenerateTitle,
      theme: theme,
      darkTheme: darkTheme,
      highContrastTheme: highContrastTheme,
      highContrastDarkTheme: highContrastDarkTheme,
      themeMode: themeMode,
      themeAnimationDuration: themeAnimationDuration,
      themeAnimationCurve: themeAnimationCurve,
      color: color,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: materialAppRestorationScopeId,
      scrollBehavior: scrollBehavior,
      themeAnimationStyle: themeAnimationStyle,
    );
  }

  static _addDefaultPageBuilderToRoutes({
    required List<RouteBase> routes,
    required RouteTreeDefaultPageBuilder? pageBuilder,
    required RouteTreeDefaultShellPageBuilder? shellPageBuilder,
  }) {
    for (RouteBase route in routes) {
      if (route is TreeRoute && pageBuilder != null) {
        TreeRoute treeRoute = route;
        route = treeRoute.withPageBuilder((_, __) => pageBuilder(_, __, treeRoute.pageWidget!));
      }
      else if (route is TreeShellRoute && shellPageBuilder != null) {
        TreeShellRoute treeShellRoute = route;
        route = treeShellRoute.withPageBuilder((_, __, child) => shellPageBuilder(_, __, treeShellRoute.pageWidget!(child), child));
      }
      if (route.routes.isNotEmpty) {
        _addDefaultPageBuilderToRoutes(routes: route.routes, pageBuilder: pageBuilder, shellPageBuilder: shellPageBuilder,);
      }
    }
  }

  static NavigationInterface get navigator{
    return GetIt.instance<NavigationInterface>();
  }
}

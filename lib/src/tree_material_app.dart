import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../tree_navigation.dart';
import 'package:get_it/get_it.dart';

import 'navigation_one_service.dart';

typedef RouteTreeDefaultPageBuilder = Page<dynamic> Function(
  BuildContext context,
  GoRouterState state,
  Widget widget,
  String routeName,
);
typedef RouteTreeDefaultShellPageBuilder = Page<dynamic> Function(
  BuildContext context,
  GoRouterState state,
  Widget Function(Widget) parent,
  Widget childWidget,
);

abstract class TreeNavigation {
  static RouteTreeDefaultPageBuilder? defaultPageBuilder;
  static RouteTreeDefaultShellPageBuilder? defaultShellPageBuilder;
  static RouterConfig<Object>? routerConfig;
  static List<RouteBase>? routeTree;

  static void init({
    required List<RouteInfo> routeInfoList,
    required List<GlobalKey<NavigatorState>> globalKeyList,
    RouteTreeDefaultPageBuilder? routeTreeDefaultPageBuilder,
    RouteTreeDefaultShellPageBuilder? routeTreeDefaultShellPageBuilder,
    bool useNavigationOne = false,
  }) {
    TreeNavigation.defaultPageBuilder = routeTreeDefaultPageBuilder;
    TreeNavigation.defaultShellPageBuilder = routeTreeDefaultShellPageBuilder;

    NavigationInterface navigationInterface = useNavigationOne
        ? NavigationOneService(
            routeInfoList: routeInfoList,
            globalKeyList: globalKeyList,
          )
        : NavigationTwoService(
            routeInfoList: routeInfoList,
            globalKeyList: globalKeyList,
          );
    GetIt.instance.registerSingleton<NavigationInterface>(navigationInterface);
  }

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
  }) {
    routeTree = routes;
    routerConfig ??= RouteTree(
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
      observers: observers ?? [],
      debugLogDiagnostics: debugLogDiagnostics,
      navigatorKey: navigatorKey,
      restorationScopeId: routerRestorationScopeId,
      requestFocus: requestFocus,
    );

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

  static NavigationInterface get navigator {
    return GetIt.instance<NavigationInterface>();
  }
}

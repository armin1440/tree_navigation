import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_navigation/src/route_info.dart';
import 'package:get_it/get_it.dart';
import 'package:tree_navigation/src/transitions/my_custom_transition_page.dart';
import '../services/navigation_int.dart';
import '../tree_material_app.dart';

import '../observers/navigation_two_observer.dart';

typedef TreeRoutePageBuilder = Page<dynamic> Function(
  BuildContext context,
  GoRouterState state,
);

typedef TreeRouteWidgetBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
);

typedef TreeShellRouteBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
  Widget child,
);

typedef TreeShellRoutePageBuilder = MyCustomTransitionPage<dynamic> Function(
  BuildContext context,
  GoRouterState state,
  Widget child,
);

typedef StatefulTreeShellRouteBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
  StatefulNavigationShell navigationShell,
);

typedef StatefulTreeShellRoutePageBuilder = Page<dynamic> Function(
  BuildContext context,
  GoRouterState state,
  StatefulNavigationShell navigationShell,
);

class TreeShellRoute extends ShellRoute {
  ///This is used by defaultShellPageBuilder that might be set in RouteTree
  final Widget Function(Widget)? pageWidget;
  final String name;

  TreeShellRoute._({
    required List<RouteInfo> routeInfoList,
    super.redirect,
    super.builder,
    TreeShellRoutePageBuilder? pageBuilder,
    List<NavigatorObserver>? observers,
    required super.routes,
    super.parentNavigatorKey,
    super.navigatorKey,
    super.restorationScopeId,
    this.pageWidget,
    required this.name,
  })  : assert(pageBuilder != null || pageWidget != null, 'Either pageBuilder or pageWidget must be non null'),
        super(
          observers: [NavigationTwoObserver(routeInfoList), ...(observers ?? [])],
          pageBuilder: pageBuilder != null
              ? (context, state, widget) => pageBuilder(context, state, widget)
              : TreeNavigation.defaultShellPageBuilder != null
                  ? (context, state, widget) =>
                      TreeNavigation.defaultShellPageBuilder!(context, state, pageWidget!, widget, name)
                  : null,
        );

  factory TreeShellRoute({
    GoRouterRedirect? redirect,
    List<NavigatorObserver>? observers,
    required List<RouteBase> routes,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    GlobalKey<NavigatorState>? navigatorKey,
    String? restorationScopeId,
    Widget Function(Widget)? pageWidget,
    required String name,
  }) {
    NavigationInterface navigationInterface = GetIt.instance<NavigationInterface>();

    return TreeShellRoute._(
      routeInfoList: navigationInterface.routeInfoList,
      redirect: redirect,
      observers: observers,
      routes: routes,
      parentNavigatorKey: parentNavigatorKey,
      navigatorKey: navigatorKey,
      restorationScopeId: restorationScopeId,
      pageWidget: pageWidget,
      name: name
    );
  }

  factory TreeShellRoute.withPageBuilder({
    GoRouterRedirect? redirect,
    TreeShellRouteBuilder? builder,
    TreeShellRoutePageBuilder? pageBuilder,
    List<NavigatorObserver>? observers,
    required List<RouteBase> routes,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    GlobalKey<NavigatorState>? navigatorKey,
    String? restorationScopeId,
    required String name,
  }) {
    NavigationInterface navigationInterface = GetIt.instance<NavigationInterface>();

    return TreeShellRoute._(
      redirect: redirect,
      builder: builder,
      pageBuilder: pageBuilder,
      observers: observers,
      routes: routes,
      parentNavigatorKey: parentNavigatorKey,
      navigatorKey: navigatorKey,
      restorationScopeId: restorationScopeId,
      routeInfoList: navigationInterface.routeInfoList,
      name: name
    );
  }
}

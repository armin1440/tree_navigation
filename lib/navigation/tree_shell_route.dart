import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation_package/navigation/route_info.dart';

import 'my_navigation_observer.dart';

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

typedef TreeShellRoutePageBuilder = Page<dynamic> Function(
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
  TreeShellRoute({
    required List<RouteInfo> routeInfoList,
    super.redirect,
    super.builder,
    super.pageBuilder,
    List<NavigatorObserver>? observers,
    required super.routes,
    super.parentNavigatorKey,
    super.navigatorKey,
    super.restorationScopeId,
  }) : super(
          observers: [MyNavigationObserver(routeInfoList), ...(observers ?? [])],
        );
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_navigation/src/route_tree.dart';
import './route_info.dart';
import './tree_material_app.dart';

typedef TreeRouteExitCallback = FutureOr<bool> Function(BuildContext context, GoRouterState state);

class TreeRoute extends GoRoute {
  ///This is used by defaultPageBuilder that might be set in RouteTree
  Widget? pageWidget;
  final RouteInfo routeInfo;
  final List<RouteBase> routes;

  TreeRoute({
    required this.routeInfo,
    GoRouterWidgetBuilder? builder,
    RouteTreePageBuilder? pageBuilder,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    GoRouterRedirect? redirect,
    ExitCallback? onExit,
    this.routes= const <RouteBase>[],
    this.pageWidget,
  }) : super(
    name: routeInfo.name,
    path: routeInfo.path,
    builder: builder,
    pageBuilder: pageBuilder ?? (context, state) => TreeNavigation.defaultPageBuilder(context, state, pageWidget!),
    parentNavigatorKey: parentNavigatorKey,
    redirect: redirect,
    onExit: onExit,
    routes: routes,
  );

  TreeRoute withPageBuilder(RouteTreePageBuilder? pageBuilder) {
    return TreeRoute(
      routeInfo: routeInfo,
      builder: builder,
      pageBuilder: pageBuilder,
      parentNavigatorKey: parentNavigatorKey,
      redirect: redirect,
      onExit: onExit,
      routes: routes,
      pageWidget: pageWidget,
    );
  }
}

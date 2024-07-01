import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_navigation/src/route_tree.dart';
import './route_info.dart';
import './tree_material_app.dart';

typedef TreeRouteExitCallback = FutureOr<bool> Function(BuildContext context, GoRouterState state);

class TreeRoute extends GoRoute {
  ///This is used by defaultPageBuilder that might be set in RouteTree
  final Widget? pageWidget;
  final RouteInfo routeInfo;

  TreeRoute({
    required this.routeInfo,
    super.builder,
    RouteTreePageBuilder? pageBuilder,
    super.parentNavigatorKey,
    super.redirect,
    super.onExit,
    super.routes = const <RouteBase>[],
    this.pageWidget,
  }) : super(
    name: routeInfo.name,
    path: routeInfo.path,
    pageBuilder: pageBuilder ?? (TreeNavigation.defaultPageBuilder != null ? (context, state) => TreeNavigation.defaultPageBuilder!(context, state, pageWidget!) : null),
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

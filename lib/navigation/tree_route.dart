import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation_package/navigation/route_tree.dart';

typedef TreeRouteExitCallback = FutureOr<bool> Function(BuildContext context, GoRouterState state);

class TreeRoute extends GoRoute {
  TreeRoute({
    required super.path,
    super.name,
    super.builder,
    RouteTreePageBuilder? super.pageBuilder,
    super.parentNavigatorKey,
    super.redirect,
    super.onExit,
    super.routes = const <TreeRoute>[],
  });
}

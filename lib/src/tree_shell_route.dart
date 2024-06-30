import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_navigation/src/route_info.dart';
import 'package:get_it/get_it.dart';
import './navigation_int.dart';
import './tree_material_app.dart';

import 'my_navigation_observer.dart';

class TreeShellRoute extends ShellRoute {
  ///This is used by defaultShellPageBuilder that might be set in TreeNavigation.init
  final Widget Function(Widget)? pageWidget;

  TreeShellRoute._({
    required List<RouteInfo> routeInfoList,
    super.redirect,
    super.builder,
    RouteTreeDefaultShellPageBuilder? pageBuilder,
    List<NavigatorObserver>? observers,
    required super.routes,
    super.parentNavigatorKey,
    super.navigatorKey,
    super.restorationScopeId,
    this.pageWidget,
  }) : super(
    observers: [MyNavigationObserver(routeInfoList), ...(observers ?? [])],
    pageBuilder: pageBuilder != null ? (context, state, widget) => pageBuilder(context, state, pageWidget!, widget) : (context, state, widget) => TreeNavigation.defaultShellPageBuilder(context, state, pageWidget!, widget),
  );

  factory TreeShellRoute({
    GoRouterRedirect? redirect,
    ShellRouteBuilder? builder,
    RouteTreeDefaultShellPageBuilder? pageBuilder,
    List<NavigatorObserver>? observers,
    required List<RouteBase> routes,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    GlobalKey<NavigatorState>? navigatorKey,
    String? restorationScopeId,
    Widget Function(Widget)? pageWidget,
  }){
    NavigationInterface navigationInterface = GetIt.instance<NavigationInterface>();

    return TreeShellRoute._(
      routeInfoList: navigationInterface.routeInfoList,
      redirect: redirect,
      builder: builder,
      pageBuilder: pageBuilder,
      observers: observers,
      routes: routes,
      parentNavigatorKey: parentNavigatorKey,
      navigatorKey: navigatorKey,
      restorationScopeId: restorationScopeId,
      pageWidget: pageWidget,
    );
  }
  
  TreeShellRoute withPageBuilder(RouteTreeDefaultShellPageBuilder pageBuilder){
    return TreeShellRoute(
        redirect: redirect,
        builder: builder,
        pageBuilder: pageBuilder,
        observers: observers,
        routes: routes,
        parentNavigatorKey: parentNavigatorKey,
        navigatorKey: navigatorKey,
        restorationScopeId: restorationScopeId,
        pageWidget: pageWidget,
    );
  }
}
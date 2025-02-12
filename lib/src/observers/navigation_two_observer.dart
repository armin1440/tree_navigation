import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../tree_navigation.dart';
import 'navigation_observer_int.dart';

class NavigationTwoObserver extends NavigationObserverInterface {
  NavigationTwoObserver(super.routeInfoList);

  NavigationTwoService get navigation => TreeNavigation.navigator as NavigationTwoService;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    RouteInfo? routeInfo = findRouteByName(routeName: route.settings.name ?? '');
    RouteInfo? previousRouteInfo = findRouteByName(routeName: previousRoute?.settings.name ?? '');

    if (routeInfo != null) {
      bool skipInitialization = navigation.isPopping;
      if (!skipInitialization) {
        navigation.previousRoute = previousRouteInfo;
        navigation.initializeRoute(
          routeInfo,
          addToStack: !routeInfo.isShellRoute,
        );
      }
      log('Pushing to ${routeInfo.name} from ${previousRoute?.settings.name}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    RouteInfo? routeName = findRouteByName(routeName: route.settings.name ?? '');
    if (routeName != null) {
      RouteInfo? previousRouteInfo = findRouteByName(routeName: previousRoute?.settings.name ?? '');
      navigation.previousRoute = previousRouteInfo;
      navigation.onPoppedRoute(
        previousRoute: previousRouteInfo,
        poppedRoute: routeName,
        result: route.popped,
      );
      log('Popping to ${previousRoute?.settings.name} from ${routeName.name}');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    RouteInfo? routeName = findRouteByName(routeName: route.settings.name);

    if (navigation.isPopping && !(routeName?.isShellRoute ?? false)) {
      didPop(route, previousRoute);
      return;
    }

    if (routeName != null) {
      RouteInfo? previousRouteInfo = findRouteByName(routeName: previousRoute?.settings.name ?? '');

      if (routeName.isShellRoute) {
        List shellRouteChildren = navigation.stack.sublist(1, navigation.stack.length);
        //disposing children of the shell route because they are not disposed automatically.
        shellRouteChildren.reversed.forEach((element) {
          navigation.registeredControllers[element]?.onDispose();
        });
        //keeping the last element in the stack because it is the new page that is navigated to.
        navigation.stack = navigation.stack.where((e) => !shellRouteChildren.contains(e)).toList();
      }

      bool shouldRemoveRoute = _shouldRemoveRoute(routeInfo: routeName);
      if (shouldRemoveRoute) {
        navigation.previousRoute = previousRouteInfo;
        navigation.onRemovedRoute(
          previousRoute: previousRouteInfo,
          poppedRoute: routeName,
          updateStack: !routeName.isShellRoute,
        );
        log('Removing ${routeName.name}, previous is ${previousRoute?.settings.name}');
      }
    }
  }

  bool _shouldRemoveRoute({required RouteInfo routeInfo}) {
    if(routeInfo.isShellRoute) return true;
    List<RouteInfo> stack = navigation.stack;
    int stackLength = stack.length;
    if (stackLength > 1) {
      bool hasJustPushed = stack[stackLength - 2] == routeInfo;
      return !hasJustPushed;
    }
    return false;
  }
}

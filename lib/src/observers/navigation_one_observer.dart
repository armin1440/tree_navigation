import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../tree_navigation.dart';
import 'navigation_observer_int.dart';

class NavigationOneObserver extends NavigationObserverInterface {
  NavigationOneObserver(super.routeInfoList);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    RouteInfo? routeName = findRouteByName(routeName: route.settings.name ?? '');
    RouteInfo? previousRouteInfo = findRouteByName(routeName: previousRoute?.settings.name ?? '');
    NavigationInterface navigation = GetIt.instance<NavigationInterface>();
    if (routeName != null) {
      navigation.previousRoute = previousRouteInfo;
      navigation.initializeRoute(
        routeName,
        addToStack: !routeName.isShellRoute,
      );
      log('Pushing to ${routeName.name} from ${previousRoute?.settings.name}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    RouteInfo? routeName = findRouteByName(routeName: route.settings.name ?? '');
    if (routeName != null) {
      NavigationInterface navigation = GetIt.instance<NavigationInterface>();
      RouteInfo? previousRouteInfo = findRouteByName(routeName: previousRoute?.settings.name ?? '');
      navigation.previousRoute = previousRouteInfo;
      navigation.disposeRoute(previousRoute: previousRouteInfo, poppedRoute: routeName, result: route.popped);
      log('Popping to ${previousRoute?.settings.name} from ${routeName.name}');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    RouteInfo? routeName = findRouteByName(routeName: route.settings.name ?? '');

    if (routeName != null) {

      NavigationInterface navigation = GetIt.instance<NavigationInterface>();
      RouteInfo? previousRouteInfo = findRouteByName(routeName: previousRoute?.settings.name ?? '');
      if (routeName.isShellRoute) {
        //disposing children of the shell route because they are not disposed automatically.
        navigation.stack.sublist(0, navigation.stack.length - 1).reversed.forEach((element) {
          navigation.registeredControllers[element]?.onDispose();
        });
        //keeping the last element in the stack because it is the new page that is navigated to.
        navigation.stack = [navigation.stack.last];
      }
      navigation.previousRoute = previousRouteInfo;

      navigation.disposeRoute(
        previousRoute: previousRouteInfo,
        poppedRoute: routeName,
        updateStack: !routeName.isShellRoute,
      );
      log('Removing ${routeName.name}, previous is ${previousRoute?.settings.name}');
    }
  }
}

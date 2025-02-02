import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../tree_navigation.dart';

class NavigationObserverInterface extends NavigatorObserver {
  NavigationObserverInterface(this.routeInfoList);

  final List<RouteInfo> routeInfoList;

  RouteInfo? _findRouteByName({required String routeName}) {
    int index = routeInfoList.indexWhere((element) => element.name == routeName);
    if (index < 0) {
      return null;
    }
    return routeInfoList[index];
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    RouteInfo? routeInfo = _findRouteByName(routeName: route.settings.name ?? '');
    RouteInfo? previousRouteInfo = _findRouteByName(routeName: previousRoute?.settings.name ?? '');
    NavigationInterface navigation = GetIt.instance<NavigationInterface>();
    if (routeInfo != null) {
      navigation.previousRoute = previousRouteInfo;
      bool skipInitialization = navigation is NavigationTwoService && navigation.isPopping;
      if(!skipInitialization) {
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
    RouteInfo? routeName = _findRouteByName(routeName: route.settings.name ?? '');
    if (routeName != null) {
      NavigationInterface navigation = GetIt.instance<NavigationInterface>();
      RouteInfo? previousRouteInfo = _findRouteByName(routeName: previousRoute?.settings.name ?? '');
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
    NavigationInterface navigation = GetIt.instance<NavigationInterface>();
    if(navigation is NavigationTwoService && navigation.isPopping){
      didPop(route, previousRoute);
      return;
    }

    RouteInfo? routeName = _findRouteByName(routeName: route.settings.name ?? '');

    if (routeName != null) {
      RouteInfo? previousRouteInfo = _findRouteByName(routeName: previousRoute?.settings.name ?? '');
      if (routeName.isShellRoute) {
        //disposing children of the shell route because they are not disposed automatically.
        navigation.stack.sublist(0, navigation.stack.length - 1).reversed.forEach((element) {
          navigation.registeredControllers[element]?.onDispose();
        });
        //keeping the last element in the stack because it is the new page that is navigated to.
        navigation.stack = [navigation.stack.last];
      }
      navigation.previousRoute = previousRouteInfo;

      bool shouldRemoveRoute = !_shouldRemoveRoute(routeInfo: routeName);
      if(shouldRemoveRoute){
        navigation.onRemovedRoute(
          previousRoute: previousRouteInfo,
          poppedRoute: routeName,
          updateStack: !routeName.isShellRoute,
        );
        log('Removing ${routeName.name}, previous is ${previousRoute?.settings.name}');
      }
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    log('in didReplace: $newRoute previous route : $oldRoute');
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('in didStartUserGesture: $route previous route : $previousRoute');
  }

  @override
  void didStopUserGesture() {
    log('in didStopUserGesture');
  }

  bool _shouldRemoveRoute({required RouteInfo routeInfo}){
    NavigationInterface navigation = GetIt.instance<NavigationInterface>();
    if(navigation is NavigationOneService) return true;

    List<RouteInfo> stack = navigation.stack;
    int stackLength = stack.length;
    if(stackLength > 1){
      bool hasJustPushed = stack[stackLength-2] == routeInfo;
      return hasJustPushed;
    }
    return false;
  }
}

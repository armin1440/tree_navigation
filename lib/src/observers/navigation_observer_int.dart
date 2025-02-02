
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../tree_navigation.dart';

class NavigationObserverInterface extends NavigatorObserver {
  NavigationObserverInterface(this.routeInfoList);

  final List<RouteInfo> routeInfoList;

  RouteInfo? findRouteByName({required String routeName}) {
    int index = routeInfoList.indexWhere((element) => element.name == routeName);
    if (index < 0) {
      return null;
    }
    return routeInfoList[index];
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didStopUserGesture() {}

  bool shouldRemoveRoute({required RouteInfo routeInfo}){
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

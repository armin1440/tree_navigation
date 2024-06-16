import 'package:tree_navigation/navigation/route_info.dart';

abstract class Routes{
  static const RouteInfo home = RouteInfo(
    path: '/',
    name: 'home',
    isShellRoute: false,
  );

  static const List<RouteInfo> allRoutes = [home];
}
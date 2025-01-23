import 'package:example/initialize.dart';
import 'package:example/screens/page_a/page_a.dart';
import 'package:example/screens/page_b/page_b.dart';
import 'package:example/screens/page_c/page_c.dart';
import 'package:example/screens/page_d/page_d.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tree_navigation/tree_navigation.dart';

GlobalKey<NavigatorState> topKey = GlobalKey<NavigatorState>();

void main() {
  init();
  runApp(
    RouteProvider(child: const MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  initState() {
    super.initState();
    GetIt.instance.registerSingleton(ref);
    initControllers();
  }

  @override
  Widget build(BuildContext context) {
    return TreeNavigation.makeMaterialApp(
      navigatorKey: topKey,
      globalKeyList: [topKey],
      routeInfoList: Routes.allRoutes,
      routes: [
        TreeRoute(
          routeInfo: Routes.pageA,
          pageWidget: const PageA(),
        ),
        TreeRoute(
          routeInfo: Routes.pageB,
          pageWidget: const PageB(),
        ),
        TreeRoute(
          routeInfo: Routes.pageC,
          pageWidget: const PageC(),
        ),
        TreeRoute(
          routeInfo: Routes.pageD,
          pageWidget: const PageD(),
        ),
      ],
    );
  }
}

abstract class Routes {
  static const RouteInfo pageB = RouteInfo(
    path: '/b',
    name: 'B',
    isShellRoute: false,
  );
  static const RouteInfo pageA = RouteInfo(
    path: '/',
    name: 'A',
    isShellRoute: false,
  );
  static const RouteInfo pageC = RouteInfo(
    path: '/c',
    name: 'C',
    isShellRoute: false,
  );
  static const RouteInfo pageD = RouteInfo(
    path: '/d',
    name: 'D',
    isShellRoute: false,
  );

  static const List<RouteInfo> allRoutes = [pageB, pageA, pageC, pageD];
}
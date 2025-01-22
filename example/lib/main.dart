import 'package:flutter/material.dart';
import 'package:tree_navigation/tree_navigation.dart';

GlobalKey<NavigatorState> topKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> shellKey = GlobalKey<NavigatorState>();

void main() async {
  runApp(
    RouteProvider(child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    TreeNavigation.init(
      useNavigationOne: false,
      globalKeyList: [topKey, shellKey],
      routeInfoList: Routes.allRoutes,
      routeTreeDefaultPageBuilder: (_, state, child, routeName) => MyCustomTransitionPage(
        key: state.pageKey,
        child: child,
        name: routeName,
        transitionsBuilder: (_, animation, ___, widget) {
          return FadeTransition(
            opacity: animation,
            child: widget,
          );
        },
      ),
      routeTreeDefaultShellPageBuilder: (_, state, parent, child) => MyCustomTransitionPage(
        key: state.pageKey,
        child: parent(child),
        transitionsBuilder: (_, animation, ___, widget) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: widget,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TreeNavigation.makeMaterialApp(
      navigatorKey: topKey,
      globalKeyList: [topKey, shellKey],
      routeInfoList: Routes.allRoutes,
      routes: [
        TreeRoute(
          routeInfo: Routes.pageD,
          pageWidget: const PageD(),
        ),
        TreeRoute(
          routeInfo: Routes.pageB,
          pageWidget: const PageB(),
          routes: [
            TreeRoute(
              routeInfo: Routes.pageD,
              pageWidget: const PageD(),
            ),
          ],
        ),
        TreeRoute(
          routeInfo: Routes.pageA,
          pageWidget: const PageA(),
          routes: [
            TreeRoute(
              routeInfo: Routes.pageC,
              pageWidget: const PageC(),
              routes: [
                TreeRoute(
                  routeInfo: Routes.pageD,
                  pageWidget: const PageD(),
                ),
              ],
            ),
          ],
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

class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page A')),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GoButton(route: Routes.pageB),
              GoButton(route: Routes.pageC),
              GoButton(route: Routes.pageD),
              GoButton(
                route: Routes.pageD,
                parent: Routes.pageC,
              ),
              GoButton(
                route: Routes.pageD,
                parent: Routes.pageB,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageB extends StatelessWidget {
  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page B')),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GoButton(route: Routes.pageA),
              GoButton(route: Routes.pageD),
            ],
          ),
        ),
      ),
    );
  }
}

class PageC extends StatelessWidget {
  const PageC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page C')),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PopButton(),
              GoButton(
                route: Routes.pageD,
                parent: Routes.pageC,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageD extends StatelessWidget {
  const PageD({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page D')),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PopButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class GoButton extends StatelessWidget {
  const GoButton({super.key, required this.route, this.parent});

  final RouteInfo route;
  final RouteInfo? parent;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => TreeNavigation.navigator.goNamed(route, parentPath: parent),
      child: Text(
        'To ${parent?.path ?? ''}${route.path}',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class PopButton extends StatelessWidget {
  const PopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => TreeNavigation.navigator.pop(),
      child: const Text(
        'Pop',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

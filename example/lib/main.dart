import 'package:flutter/material.dart';
import 'package:tree_navigation/tree_navigation.dart';

GlobalKey<NavigatorState> topKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> shellKey = GlobalKey<NavigatorState>();

void main() async {
  runApp(RouteProvider(child: const MyApp()));
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
      globalKeyList: [topKey, shellKey],
      routeInfoList: Routes.allRoutes,
      routeTreeDefaultPageBuilder: (_, state, child) => MyCustomTransitionPage(
        key: state.pageKey,
        child: child,
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
          routeInfo: Routes.home,
          pageWidget: const MyHomePage(
            title: 'Home',
            color: Colors.white,
          ),
        ),
        TreeShellRoute(
          navigatorKey: shellKey,
          pageWidget: (child) => MyHomePage(
            title: 'Shell Route',
            color: Colors.blue,
            child: child,
          ),
          routes: [
            TreeRoute(
              routeInfo: Routes.newPage,
              pageWidget: const MyHomePage(
                title: 'Sub Shell',
                color: Colors.pink,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

abstract class Routes {
  static const RouteInfo home = RouteInfo(
    path: '/',
    name: 'home',
    isShellRoute: false,
  );
  static const RouteInfo newPage = RouteInfo(
    path: '/newPage',
    name: 'newPage',
    isShellRoute: false,
  );

  static const List<RouteInfo> allRoutes = [home, newPage];
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.child, required this.color});

  final String title;
  final Widget? child;
  final Color color;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void changePage() {
    TreeNavigation.navigator.goNamed(Routes.newPage);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == 'Sub Shell') {
      return Container(
        color: widget.color,
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[if (widget.child != null) widget.child! else Text(widget.title)],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      backgroundColor: widget.color,
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[if (widget.child != null) widget.child! else Text(widget.title)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: changePage,
        tooltip: 'Change Page',
        child: const Icon(Icons.change_circle),
      ),
    );
  }
}

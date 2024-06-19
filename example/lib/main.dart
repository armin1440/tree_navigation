import 'package:flutter/material.dart';
import 'package:tree_navigation/tree_navigation.dart';

GlobalKey<NavigatorState> topKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> shellKey = GlobalKey<NavigatorState>();

void main() async {
  runApp(RouteProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TreeNavigation.makeMaterialApp(
      navigatorKey: topKey,
      globalKeyList: [topKey, shellKey],
      defaultPageBuilder: (_, state, child) => MyCustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (_, animation, ___, widget) {
          return FadeTransition(
            opacity: animation,
            child: widget,
          );
        },
      ),
      defaultShellPageBuilder: (_, state, parent, child) => MyCustomTransitionPage(
        key: state.pageKey,
        child: child,
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
      routeInfoList: Routes.allRoutes,
      routes: [
        TreeRoute(
          routeInfo: Routes.home,
          pageWidget: const MyHomePage(
            title: 'Home',
          ),
        ),
        TreeShellRoute(
          navigatorKey: shellKey,
          pageWidget: (child) => MyHomePage(title: 'Shell Route', child: child),
          routes: [
            TreeRoute(routeInfo: Routes.newPage),
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
  const MyHomePage({super.key, required this.title, this.child});

  final String title;
  final Widget? child;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void changePage() {
    TreeNavigation.navigator.goNamed(Routes.newPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[if (widget.child != null) widget.child! else const Text("You are using tree navigation")],
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

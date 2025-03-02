import 'package:example/DotButton.dart';
import 'package:flutter/material.dart';
import 'package:tree_navigation/tree_navigation.dart';

GlobalKey<NavigatorState> topKey = GlobalKey<NavigatorState>(debugLabel: 'TopKey');
GlobalKey<NavigatorState> shellKey = GlobalKey<NavigatorState>(debugLabel: 'ShellKey');

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
      useNavigationOne: true,
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
      routeInfoList: Routes.allRoutes,
      routes: [
        TreeRoute(
          routeInfo: Routes.home,
          pageWidget: const MyHomePage(),
        ),
        TreeRoute(
          routeInfo: Routes.page3,
          pageWidget: const Page3(),
        ),
        TreeShellRoute(
          navigatorKey: shellKey,
          pageWidget: (child) => Page1(child: child),
          routes: [
            TreeRoute(
              routeInfo: Routes.page2,
              pageWidget: const Page2(),
            )
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
  static const RouteInfo page1 = RouteInfo(
    path: '/page1',
    name: 'page1',
    isShellRoute: false,
  );

  static const RouteInfo page2 = RouteInfo(
    path: '/page2',
    name: 'page2',
    isShellRoute: false,
  );
  static const RouteInfo page3 = RouteInfo(
    path: '/page3',
    name: 'page3',
    isShellRoute: false,
  );

  static const List<RouteInfo> allRoutes = [page1, home, page2, page3];
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BackButton(),
            TextButton(
              onPressed: () {
                String? name = RouteProvider.of(context)?.name;
                TreeNavigation.navigator.showTextToast(text: 'name: $name');
              },
              child: Text('text toast'),
            ),
            TextButton(
              onPressed: () {
                TreeNavigation.navigator.goNamed(Routes.page2);
              },
              child: const Text('To Page2'),
            ),
            TextButton(
              onPressed: () {
                TreeNavigation.navigator.goNamed(Routes.page3);
              },
              child: const Text('To Page3'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Page1'),
      ),
      backgroundColor: Colors.green,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(100),
        child: child,
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Page2'),
      ),
      backgroundColor: Colors.yellow,
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const BackButton(),
            TextButton(
              onPressed: () {
                String? name = RouteProvider.of(context)?.name;
                TreeNavigation.navigator.showTextToast(text: 'name: $name');
              },
              child: const Text('Name'),
            ),
            TextButton(
              onPressed: () {
                TreeNavigation.navigator.goNamed(Routes.home);
              },
              child: const Text('to home'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Page3'),
      ),
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const BackButton(),
            TextButton(
              onPressed: () {
                String? name = RouteProvider.of(context)?.name;
                TreeNavigation.navigator.showTextToast(text: 'name: $name');
              },
              child: const Text('Name'),
            ),
            TextButton(
              onPressed: () {
                TreeNavigation.navigator.goNamed(Routes.home);
              },
              child: const Text('to home'),
            ),
          ],
        ),
      ),
    );
  }
}


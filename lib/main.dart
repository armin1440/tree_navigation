import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation_package/navigation/route_provider.dart';

import 'initialize.dart';
import 'navigation/my_custom_transition_page.dart';
import 'navigation/route_tree.dart';
import 'navigation/routes.dart';
import 'navigation/tree_route.dart';

final navigationKey = GlobalKey<NavigatorState>(debugLabel: 'navigationKey');

void main() async {
  await init();
  runApp(RouteProvider(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final RouteTree routeTree;

  @override
  void initState() {
    super.initState();
    routeTree = RouteTree(
      navigatorKey: navigationKey,
      debugLogDiagnostics: true,
      initialLocation: '/',
      routeInfoList: Routes.allRoutes,
      routes: [
        TreeRoute(
          parentNavigatorKey: navigationKey,
          name: Routes.home.name,
          path: Routes.home.path,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MyCustomTransitionPage(
              key: state.pageKey,
              name: Routes.home.name,
              child: const MyHomePage(title: 'My Navigation Home'),
              transitionsBuilder: (context, animation1, animation2, child) => FadeTransition(
                opacity: animation1,
                child: child,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routeTree,
      builder: BotToastInit(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

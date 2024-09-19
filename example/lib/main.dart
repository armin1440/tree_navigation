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
      globalKeyList: [topKey, shellKey],
      routeInfoList: Routes.allRoutes,
      routeTreeDefaultPageBuilder: (_, state, child) => MyCustomTransitionPage(
        key: state.pageKey,
        child: child,
        // name: routeName,
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

  void pop() {
    TreeNavigation.navigator.pop(result: 'Result');
  }

  @override
  Widget build(BuildContext context) {
    return TreeNavigation.makeMaterialApp(
      navigatorKey: topKey,
      globalKeyList: [topKey, shellKey],
      routeInfoList: Routes.allRoutes,
      routes: [
        TreeRoute(
          routeInfo: Routes.home1,
          pageWidget: MyHomePage(
            title: 'Home1',
            color: Colors.indigo,
            onPressedButton: () => TreeNavigation.navigator.go(Routes.newPage2.path, parentPath: Routes.newPage.path).then(
                  (res) => print('Page1 Home Result is : $res'),
                ),
          ),
          routes: [
            TreeRoute(
              routeInfo: Routes.newPage2,
              pageWidget: MyHomePage(
                title: 'Sub2',
                color: Colors.orange,
                onPressedButton: () {
                  TreeNavigation.navigator
                      .openDialog(
                    dialog: Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Pop Me'),
                          TextButton(
                            onPressed: () => TreeNavigation.navigator.pop(result: 'sub2 dialog'),
                            child: Text('POP'),
                          ),
                        ],
                      ),
                    ),
                  )
                      .then(
                    (value) {
                      print('After dialog pop: $value');
                    },
                  );
                },
                hasPopButton: true,
              ),
            )
          ],
        ),
        TreeRoute(
          routeInfo: Routes.home,
          pageWidget: MyHomePage(
            title: 'Home',
            color: Colors.white,
            onPressedButton: () =>
                TreeNavigation.navigator.go(Routes.home1.path).then((res) => print('Page Home Result is : $res')),
          ),
          routes: [
            TreeRoute(
              routeInfo: Routes.newPage,
              pageBuilder: (_, state) => MyCustomTransitionPage(
                key: state.pageKey,
                // name: Routes.newPage.name,
                child: MyHomePage(
                  title: 'Sub',
                  color: Colors.pink,
                  onPressedButton: () => TreeNavigation.navigator
                      .goNamed(Routes.newPage2)
                      .then((result) => print('Page Sub Result is : $result')),
                  hasPopButton: true,
                ),
                transitionsBuilder: (_, animation, ___, widget) {
                  return FadeTransition(
                    opacity: animation,
                    child: widget,
                  );
                },
              ),
              routes: [
                TreeRoute(
                  routeInfo: Routes.newPage2,
                  pageWidget: MyHomePage(
                    title: 'Sub2',
                    color: Colors.orange,
                    onPressedButton: () {
                      TreeNavigation.navigator
                          .openDialog(
                        dialog: Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Pop Me'),
                              TextButton(
                                onPressed: () => TreeNavigation.navigator.pop(result: 'sub2 dialog'),
                                child: Text('POP'),
                              ),
                            ],
                          ),
                        ),
                      )
                          .then(
                        (value) {
                          print('After dialog pop: $value');
                        },
                      );
                    },
                    hasPopButton: true,
                  ),
                ),
              ],
            ),
          ],
        ),
        // TreeShellRoute(
        //   navigatorKey: shellKey,
        //   pageWidget: (child) => MyHomePage(
        //     title: 'Shell Route',
        //     color: Colors.blue,
        //     canPop: true,
        //     child: child,
        //   ),
        //   routes: [
        //     TreeRoute(
        //       routeInfo: Routes.newPage,
        //       pageWidget: const MyHomePage(
        //         title: 'Sub Shell',
        //         color: Colors.pink,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

abstract class Routes {
  static const RouteInfo home1 = RouteInfo(
    path: '/h1',
    // name: 'home',
    isShellRoute: false,
  );
  static const RouteInfo home = RouteInfo(
    path: '/',
    // name: 'home',
    isShellRoute: false,
  );
  static const RouteInfo newPage = RouteInfo(
    path: 'newPage',
    // name: 'newPage',
    isShellRoute: false,
  );
  static const RouteInfo newPage2 = RouteInfo(
    path: 'newPage2',
    // name: 'newPage2',
    isShellRoute: false,
  );

  static const List<RouteInfo> allRoutes = [home1, home, newPage, newPage2];
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    this.child,
    required this.color,
    required this.onPressedButton,
    this.hasPopButton = false,
  });

  final String title;
  final Widget? child;
  final Color color;
  final Function onPressedButton;
  final bool hasPopButton;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
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
          children: <Widget>[
            if (widget.child != null) widget.child! else Text(widget.title),
            if (widget.hasPopButton)
              TextButton(
                onPressed: () => TreeNavigation.navigator.pop(result: widget.title),
                child: const Text('Pop'),
              ),
            TextButton(
              onPressed: () {
                // print(RouteProvider.of(context)?.name);
              },
              child: Text('My Route'),
            ),
            if (widget.title == 'Home')
              TextButton(
                onPressed: () {
                  TreeNavigation.navigator
                      .openDialog(
                          dialog: Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Pop Me'),
                            TextButton(
                              onPressed: () => TreeNavigation.navigator.pop(result: 'home dialog'),
                              child: Text('POP'),
                            ),
                            TextButton(
                              onPressed: () {
                                TreeNavigation.navigator
                                    .goNamed(Routes.newPage)
                                    .then((v) => print('In home dialog, sub pop result is: $v'));
                              },
                              child: Text('To Sub'),
                            ),
                          ],
                        ),
                      ))
                      .then((value) => print('dialog result: $value'));
                },
                child: Text('Dialog'),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.onPressedButton(),
        tooltip: 'Change Page',
        child: const Icon(Icons.change_circle),
      ),
    );
  }
}

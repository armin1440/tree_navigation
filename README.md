# Tree Navigation

A package for navigation based on the GoRouter.

## Initialization

Wrap MyApp into RouteProvider.

```
void main() async {
  await init();
  runApp(RouteProvider(child: const MyApp()));
}
```

Inside MyApp widget initialize tree navigation. routeTreeDefaultPageBuilder and
routeTreeDefaultShellPageBuilder are optional for init method. If you do not pass them then you must
pass builder or pageBuilder for every TreeRoute or TreeShellRoute.
Note that globalKeys should be sorted in order of level. The top most keys come earlier in the list.  

```
  GlobalKey<NavigatorState> topKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> shellKey = GlobalKey<NavigatorState>();
  
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

  initState(){
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
```

In build method of MyApp widget do as following:
```
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
          pageWidget: (child) => MyHomePage(title: 'Shell Route', color: Colors.blue, child: child,),
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
```

## Usage

You can access current route by:
RouteProvider.of(context)?.name;

Navigate to a screen by:

```
final navigation = GetIt.instance<NavigationInterface>();
navigation.goNamed(Routes.home);
```

Open a dialog by:

```
await navigation.openDialog<String>(dialog: const MyDialog());
```

Open a bottomSheet by:

```
await navigation.openBottomSheet<String>(bottomSheet: const MyBottomSheet());
```

Show a text toast by (You can use this instead of snackbar):

```
navigation.showTextToast(text: 'this is a toast');
```

Pop a dialog, bottomsheet or a screen by:

```
navigation.pop();
```

Pop all dialogs by:

```
navigation.popAllDialogs();
```

Pop all bottomsheets by:

```
navigation.popAllBottomSheets();
```

Pop all dialogs and bottomsheets by:

```
navigation.popAllPopUps();
```

Pop until a condition is satisfied:

```
navigation.popUntilRoute(verifyCondition: (currentRoute) {
      return currentRoute == Routes.home;
    });
```

Pop until reaching a pop up:

```
navigation.popUntilPopUp(verifyCondition: (currentPopUpName) => popUpName == currentPopUpName);
```

Show an overlay widget:

```
final handler = navigation.showOverlay(
      child: Container(
        color: Colors.brown,
        child: const Text('Other overlay'),
      ),
      alignment: Alignment.topLeft,
    );
```

Dispose an overlay widget:

```
handler.remove();
handler.dispose();
```

Get context by:

```
navigation.context;
```

Check if there is any open dialog by:

```
navigation.isDialogOpen();
```

Check if there is any open bottomsheets by:

```
navigation.isBottomSheetOpen();
```

Check if there is any open dialog or bottomsheets by:

```
navigation.isDialogOrBottomSheetOpen();
```

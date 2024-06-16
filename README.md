# Tree Navigation
A package for navigation based on the GoRouter. This package depends on flutter_riverpod, bot_toast, go_router, get_it and shared_perferences packages.


## Initialization
Before running runApp command you need to initialize navigation and shared preferences. In order to do so, just run init method before runApp. Also Wrap MyApp into RouteProvider.
```
final navigationKey = GlobalKey<NavigatorState>(debugLabel: 'navigationKey');

void main() async {
  await init();
  runApp(RouteProvider(child: const MyApp()));
}

init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initPackages();
}

_initPackages() async {
  await _initSharedPreferences();
  _initNavigation();
}

_initSharedPreferences() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  SharedPreferencesInterface sharedPreferencesInterface = SharedPreferencesImplementation(sp);
  GetIt.instance.registerSingleton(sharedPreferencesInterface);
}

_initNavigation() {
  NavigationInterface navigationInterface = NavigationService(
    routeInfoList: Routes.allRoutes,
    globalKeyList: [navigationKey],
  );
  GetIt.instance.registerSingleton(navigationInterface);
}

abstract class Routes{
  static const RouteInfo home = RouteInfo(
    path: '/',
    name: 'home',
    isShellRoute: false,
  );

  static const List<RouteInfo> allRoutes = [home];
}
```

Then create and pass a RouteTree object to MaterialApp.router. Also pass BotToastInit() to MaterialApp.router:
```
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
```
You can have TreeRoute or TreeShellRoute. They are as same as GoRoute and ShellRoute.


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

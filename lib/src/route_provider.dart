import 'package:flutter/cupertino.dart';
import 'package:tree_navigation/src/route_info.dart';

class RouteProvider extends InheritedNotifier<RouteInfoNotifier> {
  const RouteProvider._({
    super.key,
    super.notifier,
    required super.child,
  });

  factory RouteProvider({Key? key, required Widget child}) {
    return RouteProvider._(
      key: key,
      notifier: RouteInfoNotifier.instance,
      child: child,
    );
  }

  static RouteInfo? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RouteProvider>()!.notifier!.value;
  }

  @override
  bool updateShouldNotify(covariant InheritedNotifier<RouteInfoNotifier> oldWidget) {
    return notifier!.value != oldWidget.notifier!.value;
  }

  static updateRoute({required BuildContext context, required RouteInfo? routeName}) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      RouteInfoNotifier.instance.updateRoute(newRoute: routeName);
    });
  }
}

class RouteInfoNotifier extends ChangeNotifier {
  RouteInfo? value;

  RouteInfoNotifier._({required this.value});

  static final RouteInfoNotifier instance = RouteInfoNotifier._(value: null);

  void updateRoute({required RouteInfo? newRoute}) {
    if (value != newRoute) {
      value = newRoute;
      notifyListeners();
    }
  }
}

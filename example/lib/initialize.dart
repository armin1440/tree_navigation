import 'package:example/screens/page_a/a_controller.dart';
import 'package:example/screens/page_b/b_controller.dart';
import 'package:example/screens/page_c/c_controller.dart';
import 'package:example/screens/page_d/d_controller.dart';
import 'package:example/screens/wrapper/wrapper_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tree_navigation/tree_navigation.dart';

import 'main.dart';

void init(){
  TreeNavigation.init(
    useNavigationOne: false,
    globalKeyList: [topKey, shellKey],
    routeInfoList: Routes.allRoutes,
    routeTreeDefaultPageBuilder: (_, state, child, routeName) => MyCustomTransitionPage(
      key: state.pageKey,
      isShellRoute: false,
      child: child,
      name: routeName,
      transitionsBuilder: (_, animation, ___, widget) {
        return FadeTransition(
          opacity: animation,
          child: widget,
        );
      },
    ),
    routeTreeDefaultShellPageBuilder: (_, state, parent, child, name) => MyCustomTransitionPage(
      key: state.pageKey,
      isShellRoute: true,
      child: parent(child),
      name: name,
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

void initControllers() {
  NavigationInterface ns = GetIt.instance<NavigationInterface>();
  AController aController = AController();
  BController bController = BController();
  CController cController = CController();
  DController dController = DController();
  WrapperController wrapperController = WrapperController();


  GetIt.instance.registerSingleton(aController);
  GetIt.instance.registerSingleton(bController);
  GetIt.instance.registerSingleton(cController);
  GetIt.instance.registerSingleton(dController);
  GetIt.instance.registerSingleton(wrapperController);

  ns.registerAllControllers({
    Routes.pageA: aController,
    Routes.pageB: bController,
    Routes.pageC: cController,
    Routes.pageD: dController,
    Routes.wrapper: wrapperController,
  });
}
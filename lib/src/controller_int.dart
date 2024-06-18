import 'dart:developer';
import 'package:get_it/get_it.dart';

import 'navigation_int.dart';

abstract class TreeControllerInterface {
  late NavigationInterface navigation;

  TreeControllerInterface() {
    navigation = GetIt.instance<NavigationInterface>();
  }

  void onInit() {
    log("initialized $runtimeType");
  }

  void onCreate() {
    log("created $runtimeType");
  }

  void onDispose() {
    log("Disposed $runtimeType");
  }
}

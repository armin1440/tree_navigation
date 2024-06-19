import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'navigation_int.dart';

abstract class ControllerInterface {
  late NavigationInterface navigation;
  bool initialized = false;

  ControllerInterface() {
    navigation = GetIt.instance<NavigationInterface>();
    
    if (!initialized) {
      onCreate();
    }
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

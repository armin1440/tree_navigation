import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:tree_navigation/src/shared_preferences_int.dart';

import 'navigation_int.dart';

abstract class ControllerInterface {
  late NavigationInterface navigation;
  late SharedPreferencesInterface sharedPref;
  late WidgetRef ref;
  bool initialized = false;

  ControllerInterface() {
    navigation = GetIt.instance<NavigationInterface>();
    sharedPref = GetIt.instance<SharedPreferencesInterface>();
    ref = GetIt.instance<WidgetRef>();

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



import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tree_navigation/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation/navigation_int.dart';
import 'navigation/navigation_service.dart';
import 'navigation/routes.dart';
import 'navigation/shared_pref_imp.dart';
import 'navigation/shared_preferences_int.dart';

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

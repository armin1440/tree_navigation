import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tree_navigation/tree_navigation.dart';

abstract class BaseController extends ControllerInterface{
  late WidgetRef ref;

  BaseController() {
    ref = GetIt.instance<WidgetRef>();
  }
}

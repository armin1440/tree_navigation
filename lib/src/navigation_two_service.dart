import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_navigation/src/pop_result.dart';

import '../tree_navigation.dart';
import 'exceptions.dart';

class NavigationTwoService extends NavigationInterface {
  NavigationTwoService({required super.routeInfoList, required super.globalKeyList});
  bool isPopping = false;
  List<PopResult> popResultList = [];

  @override
  Future<dynamic> goNamed(
    RouteInfo route, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    RouteInfo? parentPath,
  }) async {
    if (pendingRouteFunction != null) {
      Function copiedFunction = pendingRouteFunction!;
      pendingRouteFunction = null;
      copiedFunction();
      return null;
    } else {
      String path = _tryGeneratingPath(lastPathPart: route.path, parentPath: parentPath?.path);
      PopResult newResult = PopResult();
      popResultList.add(newResult);
      context.go(
        path,
        extra: extra,
      );
      return await newResult.getFuture();
    }
  }

  @override
  Future<T?> openDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) async {
    String runtimeType = dialog.runtimeType.toString();
    String popUpName = '${currentRoute?.name}$runtimeType';
    registerPopUp(name: popUpName, key: dialog.key, isDialog: true);
    String dialogNameAndKey = openedDialogOrBottomSheetList.last;

    PopResult newResult = PopResult();
    popResultList.add(newResult);

    T? output;
    output = await showDialog<T>(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings ?? RouteSettings(name: dialogNameAndKey),
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
    );

    removePopUpNameAndKey(nameAndKey: dialogNameAndKey, isDialog: true);
    return output;
  }

  @override
  Future<T?> openBottomSheet<T>({
    required Widget bottomSheet,
    Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
  }) async {
    String runtimeType = bottomSheet.runtimeType.toString();
    String name = '${currentRoute?.name}$runtimeType';
    registerPopUp(name: name, key: bottomSheet.key, isDialog: false);
    String bottomSheetNameAndKey = openedDialogOrBottomSheetList.last;

    PopResult newResult = PopResult();
    popResultList.add(newResult);

    T? output = await showModalBottomSheet<T>(
      context: context,
      builder: (_) => bottomSheet,
      backgroundColor: backgroundColor,
      barrierLabel: barrierLabel,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings ?? RouteSettings(name: bottomSheetNameAndKey),
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
    );

    removePopUpNameAndKey(nameAndKey: bottomSheetNameAndKey, isDialog: false);
    return output;
  }

  @override
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> openSnackBar(SnackBar snackBar) {
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  CancelFunc showTextToast({required String text}) {
    CancelFunc cancel = BotToast.showText(text: text);
    return cancel;
  }

  @override
  void openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Future<void> pop({dynamic result}) async {
    isPopping = true;
    if (stack.isNotEmpty) {
      int indexOfRouteBeforeLast = stack.length - 2;
      RouteInfo? previousRoute = indexOfRouteBeforeLast < 0 ? null : stack[indexOfRouteBeforeLast];
      if (previousRoute != null) {
        await goNamed(previousRoute);
      }
      isPopping = false;
    } else {
      isPopping = false;
      throw GoError('There is nothing to pop');
    }
  }

  Future<void> _preparePopResult({dynamic result}) async {
    if (result is Future) {
      result = await result;
    }
    _completePopResult(result: result);
  }

  @override
  Future<void> onPoppedRoute({
    required RouteInfo? previousRoute,
    required RouteInfo poppedRoute,
    bool updateStack = true,
    dynamic result,
  }) async {
    await _preparePopResult(result: result);
    super.onPoppedRoute(
      previousRoute: previousRoute,
      poppedRoute: poppedRoute,
      updateStack: updateStack,
    );
  }

  @override
  Future<void> onRemovedRoute({
    required RouteInfo? previousRoute,
    required RouteInfo poppedRoute,
    bool updateStack = true,
    dynamic result,
  }) async {
    await _preparePopResult(result: result);
    super.onRemovedRoute(
      previousRoute: previousRoute,
      poppedRoute: poppedRoute,
      updateStack: updateStack,
    );
  }

  void _completePopResult({dynamic result}) {
    if (popResultList.isNotEmpty) {
      PopResult popResult = popResultList.last;
      if (!popResult.isCompleted) {
        popResult.setValue(result);
      }
      popResultList.removeLast();
    }
  }

  String _tryGeneratingPath({required String lastPathPart, required String? parentPath}) {
    String path = '';
    if (TreeNavigation.routeTree != null) {
      String? finalPath = _generateFullPath(lastPathPart: lastPathPart, parentPath: parentPath);
      if (finalPath == null) {
        throw RouteNotFoundException(lastPathPart);
      } else {
        path = finalPath;
      }
      print('Generated Path: $path');
    }
    return path;
  }

  String? _generateFullPath({
    required String lastPathPart,
    String? parentPath,
    String pathToHere = '',
    RouteBase? root,
  }) {
    List<RouteBase> routes = TreeNavigation.routeTree ?? [];
    String? output;
    for (var route in (root?.routes ?? routes)) {
      String trimmedTmpPath = route is TreeRoute ? route.path.replaceAll('/', '') : '';
      String trimmedLastPathPart = lastPathPart.replaceAll('/', '');
      if (trimmedTmpPath == trimmedLastPathPart) {
        String fullPath = '$pathToHere/$trimmedTmpPath';
        List<String> pathParts = fullPath.split('/');
        if (parentPath != null) {
          String trimmedParent = parentPath.replaceAll('/', '');
          if (pathParts.contains(trimmedParent)) {
            output = fullPath;
            break;
          }
        } else {
          output = fullPath;
          break;
        }
      }
      bool hasChildren = route.routes.isNotEmpty;
      if (hasChildren) {
        output = _generateFullPath(
          lastPathPart: lastPathPart,
          parentPath: parentPath,
          pathToHere: '$pathToHere${trimmedTmpPath.isNotEmpty ? '/' : ''}$trimmedTmpPath',
          root: route,
        );
        if (output != null) {
          break;
        }
      }
    }

    return output;
  }
}

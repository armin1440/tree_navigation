import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_navigation/src/pop_result.dart';
import 'package:tree_navigation/src/route_info.dart';

import 'navigation_int.dart';

class NavigationService extends NavigationInterface {
  NavigationService({required super.routeInfoList, required super.globalKeyList});

  List<PopResult> popResultList = [];

  @override
  Future<dynamic> goNamed(
    RouteInfo route, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    if (pendingRouteFunction != null) {
      Function copiedFunction = pendingRouteFunction!;
      pendingRouteFunction = null;
      copiedFunction();
      return null;
    } else {
      PopResult newResult = PopResult();
      popResultList.add(newResult);
      context.goNamed(
        route.name,
        pathParameters: pathParameters,
        extra: extra,
        queryParameters: queryParameters,
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
  void pop({dynamic result}) {
    if (popResultList.isNotEmpty) {
      PopResult popResult = popResultList.last;
      if (!popResult.isCompleted) {
        popResult.setValue(result);
      }
      popResultList.removeLast();
    }
    context.pop(result);
  }
}

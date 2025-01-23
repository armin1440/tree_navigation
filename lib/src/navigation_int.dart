import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:tree_navigation/src/route_info.dart';
import 'package:tree_navigation/src/route_provider.dart';
import 'controller_int.dart';

const String popUpNameAndKeySeparator = '@';

abstract class NavigationInterface {
  NavigationInterface({required this.routeInfoList, required this.globalKeyList});

  final List<RouteInfo> routeInfoList;
  final List<GlobalKey<NavigatorState>> globalKeyList;
  List<String> openedDialogOrBottomSheetList = [];
  List<String> openedDialogList = [];
  List<String> openedBottomSheetList = [];
  Map<RouteInfo, ControllerInterface> registeredControllers = {};
  List<RouteInfo> stack = [];
  Function? pendingRouteFunction;
  RouteInfo? previousRoute;

  RouteInfo? get currentRoute => RouteProvider.of(context);

  set _currentRoute(RouteInfo? newRoute) {
    RouteProvider.updateRoute(context: context, routeName: newRoute);
  }

  void registerAllControllers(Map<RouteInfo, ControllerInterface> routeToController) {
    registeredControllers = routeToController;
  }

  void initializeRoute(RouteInfo routeName, {bool addToStack = true}) {
    registeredControllers[routeName]?.onInit();
    if (addToStack) {
      stack.add(routeName);
    }
    _currentRoute = routeName;
  }

  void popRoute({
    required RouteInfo? previousRoute,
    required RouteInfo poppedRoute,
    bool updateStack = true,
    dynamic result,
  }) {
    _disposeRoute(
      previousRoute: previousRoute,
      poppedRoute: poppedRoute,
      updateStack: updateStack,
      result: result,
    );
    _currentRoute = previousRoute;
  }

  void removeRoute({
    required RouteInfo? previousRoute,
    required RouteInfo poppedRoute,
    bool updateStack = true,
    dynamic result,
  }) {
    _disposeRoute(
      previousRoute: previousRoute,
      poppedRoute: poppedRoute,
      updateStack: updateStack,
      result: result,
    );
  }

  void _disposeRoute({
    required RouteInfo? previousRoute,
    required RouteInfo poppedRoute,
    bool updateStack = true,
    dynamic result,
  }) {
    registeredControllers[poppedRoute]?.onDispose();
    if (updateStack && stack.isNotEmpty) {
      stack.removeLast();
    }
  }

  BuildContext get context {
    List<GlobalKey<NavigatorState>> reversedKeyList = globalKeyList.reversed.toList();
    for (GlobalKey<NavigatorState> key in reversedKeyList) {
      if (key.currentContext != null || key == reversedKeyList.last) {
        return key.currentContext!;
      }
    }

    return reversedKeyList.last.currentContext!;
  }

  Future<dynamic> goNamed(
    RouteInfo route, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    RouteInfo? parentPath,
  });

  // Future<dynamic> go(
  //   RouteInfo route, {
  //   Map<String, String> pathParameters = const <String, String>{},
  //   Map<String, dynamic> queryParameters = const <String, dynamic>{},
  //   Object? extra,
  //   RouteInfo? parentPath,
  // });

  Future<T?> openDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  });

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
  });

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> openSnackBar(SnackBar snackBar);

  CancelFunc showTextToast({
    required String text,
  });

  void openDrawer();

  Future<void> pop({dynamic result});

  bool get isDialogOpen => openedDialogList.isNotEmpty;

  bool get isBottomSheetOpen => openedBottomSheetList.isNotEmpty;

  bool get isDialogOrBottomSheetOpen => openedDialogOrBottomSheetList.isNotEmpty;

  void popAllDialogs({dynamic result}) {
    while (isDialogOpen) {
      pop(result: result);
      String last = openedDialogOrBottomSheetList.removeLast();
      bool isDialog = openedDialogList.contains(last);
      if (isDialog) {
        openedDialogList.remove(last);
      }
    }
  }

  void popAllBottomSheets({dynamic result}) {
    while (isBottomSheetOpen) {
      pop(result: result);
      String last = openedDialogOrBottomSheetList.removeLast();
      bool isBottomSheet = openedBottomSheetList.contains(last);
      if (isBottomSheet) {
        openedBottomSheetList.remove(last);
      }
    }
  }

  Future<void> popAllPopUps({dynamic result}) async {
    while (openedDialogOrBottomSheetList.isNotEmpty) {
      await _popLastDialogOrBottomSheet(result: result);
    }
  }

  Future<void> _popLastDialogOrBottomSheet({dynamic result}) async {
    await pop(result: result);
    String last = openedDialogOrBottomSheetList.removeLast();
    bool isBottomSheet = openedBottomSheetList.contains(last);
    if (isBottomSheet) {
      openedBottomSheetList.remove(last);
    } else {
      openedDialogList.remove(last);
    }
  }

  Future<void> popUntilRoute({required bool Function(RouteInfo) verifyCondition}) async {
    popAllPopUps();
    RouteInfo? previousRoute;
    do {
      pop();
      debugPrint('Previous is ${previousRoute?.name} and current is ${'currentRoute?.name'}');
      previousRoute = currentRoute;
    } while (previousRoute == null ? false : !verifyCondition(previousRoute));
  }

  void popUntilPopUp({required bool Function(String) verifyCondition, dynamic result}) {
    if (openedDialogOrBottomSheetList.isEmpty) return;

    String storedPopUpName = '';
    do {
      _popLastDialogOrBottomSheet(result: result);
      storedPopUpName = _getPopUpNameFromRegisteredString(popUpNameAndKey: openedDialogOrBottomSheetList.last);
    } while (!verifyCondition(storedPopUpName));
  }

  bool canPopUntilPopUp({required String popUpName}) {
    if (openedDialogOrBottomSheetList.isEmpty) return false;

    //use sublist to skip checking the last one. it pops anyway even if it is equal to the input
    bool nameIsInDialogsOrBottomSheets = openedDialogOrBottomSheetList
        .sublist(0, openedDialogOrBottomSheetList.length - 1)
        .any((element) => _getPopUpNameFromRegisteredString(popUpNameAndKey: element) == popUpName);

    return nameIsInDialogsOrBottomSheets;
  }

  void registerPopUp({
    required String name,
    required bool isDialog,
    Key? key,
  }) {
    String popUpNameAndKey = createPopUpNameAndKeyString(name: name, key: key);
    _addPopUpNameAndKey(popUpNameAndKey: popUpNameAndKey, isDialog: isDialog);
  }

  void _addPopUpNameAndKey({required String popUpNameAndKey, required bool isDialog}) {
    openedDialogOrBottomSheetList.add(popUpNameAndKey);
    if (isDialog) {
      openedDialogList.add(popUpNameAndKey);
    } else {
      openedBottomSheetList.add(popUpNameAndKey);
    }
  }

  void removePopUpNameAndKey({required String nameAndKey, required bool isDialog}) {
    openedDialogOrBottomSheetList.remove(nameAndKey);
    if (isDialog) {
      openedDialogList.remove(nameAndKey);
    } else {
      openedBottomSheetList.remove(nameAndKey);
    }
  }

  String createPopUpNameAndKeyString({required String name, Key? key}) {
    String keyString = (key ?? UniqueKey()).toString();
    return "$name$popUpNameAndKeySeparator$keyString";
  }

  String _getPopUpNameFromRegisteredString({required String popUpNameAndKey}) {
    List<String> popUpStringParts = popUpNameAndKey.split(popUpNameAndKeySeparator);
    return popUpStringParts.first;
  }

  ///The alignment priority is higher than the others.
  ///To remove an overlay use the following code:
  ///overlayEntry.remove();
  ///overlayEntry.dispose();
  OverlayEntry showOverlay<T>({
    required Widget child,
    Alignment? alignment,
    double? fromTop,
    double? fromBottom,
    double? fromRight,
    double? fromLeft,
    bool canSizeOverlay = false,
    bool maintainState = false,
    bool opaque = false,
    BuildContext? passedContext,
  }) {
    OverlayEntry overlayEntry = OverlayEntry(
      canSizeOverlay: canSizeOverlay,
      maintainState: maintainState,
      opaque: opaque,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: fromTop,
              bottom: fromBottom,
              right: fromRight,
              left: fromLeft,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  alignment: alignment,
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(passedContext ?? context, debugRequiredFor: child).insert(overlayEntry);
    return overlayEntry;
  }

  CancelFunc showToast({
    required ToastBuilder attachedBuilder,
    BuildContext? targetContext,
    Offset? target,
    WrapAnimation? wrapAnimation,
    WrapAnimation? wrapToastAnimation,
    Color backgroundColor = Colors.transparent,
    Duration? duration,
    Duration? animationDuration,
    Duration? animationReverseDuration,
    PreferDirection? preferDirection,
    VoidCallback? onClose,
  }) {
    CancelFunc cancelFunc = BotToast.showAttachedWidget(
      attachedBuilder: attachedBuilder,
      targetContext: targetContext,
      target: target,
      wrapAnimation: wrapAnimation,
      wrapToastAnimation: wrapToastAnimation,
      backgroundColor: backgroundColor,
      duration: duration,
      animationDuration: animationDuration,
      animationReverseDuration: animationReverseDuration,
      preferDirection: preferDirection,
      onClose: onClose,
    );
    return cancelFunc;
  }

  void cleanAllToasts() {
    BotToast.cleanAll();
  }
}

import 'package:go_router/go_router.dart';

class MyCustomTransitionPage<T> extends CustomTransitionPage<T> {
  const MyCustomTransitionPage({
    required super.child,
    required super.transitionsBuilder,
    super.transitionDuration = const Duration(milliseconds: 300),
    super.reverseTransitionDuration = const Duration(milliseconds: 300),
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.opaque = true,
    super.barrierDismissible = false,
    super.barrierColor,
    super.barrierLabel,
    required super.key,
    required String name,
    super.arguments,
    super.restorationId,
    required this.isShellRoute,
  })  : myName = name,
        super(name: name);

  final bool isShellRoute;
  final String myName;
}

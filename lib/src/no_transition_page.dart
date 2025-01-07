import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// Custom transition page with no transition.
class NoTransitionPage<T> extends CustomTransitionPage<T> {
  /// Constructor for a page with no transition functionality.
  const NoTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
    transitionsBuilder: _transitionsBuilder,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );

  static Widget _transitionsBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) =>
      child;
}
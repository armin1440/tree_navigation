import 'package:flutter/material.dart';
import 'package:tree_navigation/tree_navigation.dart';

class GoButton extends StatelessWidget {
  const GoButton({super.key, required this.route, this.parent});

  final RouteInfo route;
  final RouteInfo? parent;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => TreeNavigation.navigator.goNamed(route, parentPath: parent),
      child: Text(
        'To ${parent?.path ?? ''}${route.path}',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
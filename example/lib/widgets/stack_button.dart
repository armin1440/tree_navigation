import 'package:flutter/material.dart';
import 'package:tree_navigation/tree_navigation.dart';

class StackButton extends StatelessWidget {
  const StackButton({super.key});

  @override
  Widget build(BuildContext context) {
    List<RouteInfo> stack = TreeNavigation.navigator.stack;
    String stackString = stack.fold('', (value, route) => '$value,${route.name}');
    return TextButton(
      onPressed: () => TreeNavigation.navigator.showTextToast(text: stackString),
      child: const Text(
        'Stack',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

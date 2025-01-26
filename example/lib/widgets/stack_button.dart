import 'package:flutter/material.dart';
import 'package:tree_navigation/tree_navigation.dart';

class StackButton extends StatelessWidget {
  const StackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        List<RouteInfo> stack = TreeNavigation.navigator.stack;
        String stackString = stack.fold('', (value, route) => '$value,${route.name}');
        TreeNavigation.navigator.showTextToast(text: stackString);
      },
      child: const Text(
        'Stack',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

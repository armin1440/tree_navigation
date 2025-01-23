import 'package:flutter/material.dart';
import 'package:tree_navigation/tree_navigation.dart';

class PopButton extends StatelessWidget {
  const PopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => TreeNavigation.navigator.pop(),
      child: const Text(
        'Pop',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
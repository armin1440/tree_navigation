import 'package:flutter/material.dart';
import 'package:tree_navigation/tree_navigation.dart';

class PageNameButton extends StatelessWidget {
  const PageNameButton({super.key});

  @override
  Widget build(BuildContext context) {
    String currentPageName = RouteProvider.of(context)?.name ?? 'Unknown';

    return TextButton(
      onPressed: () => TreeNavigation.navigator.showTextToast(text: 'I am page "$currentPageName"'),
      child: const Text(
        'Introduce Me',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
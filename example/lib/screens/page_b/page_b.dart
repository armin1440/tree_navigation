import 'package:flutter/material.dart';

import '../../main.dart';
import '../../widgets/go_button.dart';
import '../../widgets/page_name_button.dart';

class PageB extends StatelessWidget {
  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page B')),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GoButton(route: Routes.pageA),
              GoButton(route: Routes.pageD),
              PageNameButton(),
            ],
          ),
        ),
      ),
    );
  }
}

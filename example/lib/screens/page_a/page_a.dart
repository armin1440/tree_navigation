import 'package:flutter/material.dart';

import '../../main.dart';
import '../../widgets/go_button.dart';
import '../../widgets/page_name_button.dart';

class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page A')),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GoButton(route: Routes.pageB),
              GoButton(route: Routes.pageC),
              GoButton(route: Routes.pageD),
              GoButton(
                route: Routes.pageD,
                parent: Routes.pageC,
              ),
              GoButton(
                route: Routes.pageD,
                parent: Routes.pageB,
              ),
              PageNameButton(),
            ],
          ),
        ),
      ),
    );
  }
}

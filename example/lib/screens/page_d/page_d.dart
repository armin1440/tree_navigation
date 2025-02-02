import 'package:example/widgets/go_button.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../widgets/page_name_button.dart';
import '../../widgets/pop_button.dart';
import '../../widgets/stack_button.dart';

class PageD extends StatelessWidget {
  const PageD({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page D')),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GoButton(route: Routes.pageA),
              PageNameButton(),
              StackButton(),
              PopButton(),
            ],
          ),
        ),
      ),
    );
  }
}
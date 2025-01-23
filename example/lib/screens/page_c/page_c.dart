import 'package:flutter/material.dart';

import '../../main.dart';
import '../../widgets/go_button.dart';
import '../../widgets/page_name_button.dart';
import '../../widgets/pop_button.dart';

class PageC extends StatelessWidget {
  const PageC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page C')),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PopButton(),
              GoButton(
                route: Routes.pageD,
                parent: Routes.pageC,
              ),
              PageNameButton(),
            ],
          ),
        ),
      ),
    );
  }
}
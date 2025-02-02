import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WrapperView extends ConsumerStatefulWidget {
  const WrapperView({super.key, required this.child});

  final Widget child;

  @override
  WrapperViewState createState() => WrapperViewState();
}

class WrapperViewState extends ConsumerState<WrapperView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Wrapper Page'),
      ),
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}

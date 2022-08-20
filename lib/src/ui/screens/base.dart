import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    required this.child,
    this.background,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background ?? Theme.of(context).colorScheme.background,
      body: SafeArea(child: child),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(child: Center(child: Text('Home Screen')));
  }
}

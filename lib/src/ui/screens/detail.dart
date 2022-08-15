import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(child: Center(child: Text('Movie Detail Screen')));
  }
}

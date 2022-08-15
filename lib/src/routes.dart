import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/ui/screens/home.dart';

Map<String, WidgetBuilder> getRoutes(RouteSettings settings) {
  return {
    MovieRoute.homeScreen.route: (context) => const HomeScreen(),
  };
}

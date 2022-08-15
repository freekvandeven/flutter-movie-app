import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/config/theme.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/routes.dart';

class MovieViewingAppApp extends StatelessWidget {
  const MovieViewingAppApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getTheme(),
      initialRoute: MovieRoute.homeScreen.route,
      onGenerateRoute: (settings) {
        var routes = getRoutes(settings);
        if (routes.containsKey(settings.name)) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => routes[settings.name]!(context),
            settings: settings,
          );
        } else {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => const Text('Page not found'),
            settings: settings,
          );
        }
      },
    );
  }
}

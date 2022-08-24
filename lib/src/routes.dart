// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/ui/screens/detail.dart';
import 'package:movie_viewing_app/src/ui/screens/home.dart';
import 'package:movie_viewing_app/src/ui/screens/splash.dart';
import 'package:movie_viewing_app/src/ui/screens/view.dart';

Map<String, WidgetBuilder> getRoutes(RouteSettings settings) {
  return {
    MovieRoute.splashScreen.route: (context) => const SplashScreen(),
    MovieRoute.homeScreen.route: (context) => const HomeScreen(),
    MovieRoute.movieDetail.route: (context) => const MovieDetailScreen(),
    MovieRoute.movieView.route: (context) => const MovieViewScreen(),
  };
}

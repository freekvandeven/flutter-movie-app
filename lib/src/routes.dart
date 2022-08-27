// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/ui/screens/detail.dart';
import 'package:movie_viewing_app/src/ui/screens/home.dart';
import 'package:movie_viewing_app/src/ui/screens/splash.dart';
import 'package:movie_viewing_app/src/ui/screens/view.dart';

class AnimatedPageDefinition {
  const AnimatedPageDefinition({
    required this.page,
    this.transition,
    this.duration,
  });
  final WidgetBuilder page;
  final RouteTransitionsBuilder? transition;
  final Duration? duration;
}

Map<String, AnimatedPageDefinition> getRoutes(RouteSettings settings) => {
      MovieRoute.splashScreen.route: AnimatedPageDefinition(
        page: (context) => const SplashScreen(),
      ),
      MovieRoute.homeScreen.route: AnimatedPageDefinition(
        page: (context) => const HomeScreen(),
        transition: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
        duration: const Duration(milliseconds: 1500),
      ),
      MovieRoute.movieDetail.route: AnimatedPageDefinition(
        page: (context) => const MovieDetailScreen(),
      ),
      MovieRoute.movieView.route: AnimatedPageDefinition(
        page: (context) => const MovieViewScreen(),
      ),
    };

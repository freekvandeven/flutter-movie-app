// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:rive/rive.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieCatalogueProvider.notifier).fetchMovies();
    ref.read(actorProvider.notifier).fetchActors();
    ref.read(movieSettingsProvider.notifier).fetchMovieUserSettings();
    ref.read(configServiceProvider.notifier).loadApplicationSettings();
    // route to home screen after some time
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(MovieRoute.homeScreen.route);
        // if a movie was selected route to the movie detail screen
        var selectedMovie = ref
            .read(movieSettingsProvider)
            .where((element) => element.selected);
        if (selectedMovie.isNotEmpty) {
          Navigator.of(context).pushNamed(MovieRoute.movieDetail.route);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      child: Center(
        child: RiveAnimation.asset('assets/loading_animation.riv'),
      ),
    );
  }
}

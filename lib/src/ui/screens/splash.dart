import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    ref.read(movieCatalogueProvider.notifier).fetchMovies();
    ref.read(actorProvider.notifier).fetchActors();
    ref.read(movieSettingsProvider.notifier).fetchMovieUserSettings();
    // route to home screen after some time
    Future.delayed(const Duration(milliseconds: 1000), () {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      child:
          // show app logo in the middle of the screen
          Center(
        child: Image(
          image: AssetImage('assets/images/icons/logo.jpg'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:quick_actions/quick_actions.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String shortcut = 'no action set';

  @override
  void initState() {
    super.initState();
    ref.read(movieCatalogueProvider.notifier).fetchMovies();
    ref.read(actorProvider.notifier).fetchActors();
    ref.read(movieSettingsProvider.notifier).fetchMovieUserSettings();
    ref.read(configServiceProvider.notifier).loadApplicationSettings();
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

    var quickActions = const QuickActions()
      ..initialize((String shortcutType) {
        setState(() {
          shortcut = shortcutType;
        });
      });

    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: 'action_one',
        localizedTitle: 'Action one',
        icon: 'AppIcon',
      ),
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: 'action_two',
        localizedTitle: 'Action two',
        icon: 'ic_launcher',
      ),
    ]).then((void _) {
      setState(() {
        if (shortcut == 'no action set') {
          shortcut = 'actions ready';
        }
      });
    });
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

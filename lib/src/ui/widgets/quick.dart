import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickActionsWidget extends ConsumerStatefulWidget {
  const QuickActionsWidget({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  ConsumerState<QuickActionsWidget> createState() => _QuickActionsWidgetState();
}

class _QuickActionsWidgetState extends ConsumerState<QuickActionsWidget> {
  String shortcut = 'no action set';
  late QuickActions quickActions;

  @override
  void initState() {
    super.initState();
    quickActions = const QuickActions();
    quickActions.initialize((shortcutType) {
      if (shortcutType.contains('action')) {
        debugPrint('The user tapped on the movie action. $shortcutType');
        // retrieve the movie title from the action and set it to selected
        _routeToSelectedMovie(shortcutType);
      }
    });
  }

  Future<void> _routeToSelectedMovie(String shortcutType) async {
    var movieTitle = shortcutType.split('_')[1];
    for (var movie in ref
        .read(movieSettingsProvider)
        .where((element) => element.selected)) {
      await ref
          .read(movieSettingsProvider.notifier)
          .updateMovieUserSettings(movie.copyWith(selected: false));
    }

    var movieSetting = ref
        .read(movieSettingsProvider)
        .firstWhere((element) => element.title == movieTitle);
    await ref
        .read(movieSettingsProvider.notifier)
        .updateMovieUserSettings(movieSetting.copyWith(selected: true));
    Future.delayed(const Duration(milliseconds: 1), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
        MovieRoute.homeScreen.route,
        (route) => false,
      );
      Navigator.of(context).pushNamed(MovieRoute.movieDetail.route);
      Navigator.of(context).pushNamed(MovieRoute.movieView.route);
    });
  }

  void setMovieLaunchers() {
    var movies = ref
        .watch(movieSettingsProvider)
        .where((element) => element.timeWatched > 60)
        .toList();
    quickActions.setShortcutItems(<ShortcutItem>[
      for (var movie in movies) ...[
        ShortcutItem(
          type: 'action_${movie.title}',
          localizedTitle: 'Continue ${movie.title}',
          icon: Platform.isIOS ? 'AppIcon' : 'launcher_icon',
        ),
      ]
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
    setMovieLaunchers();
    return widget.child;
  }
}

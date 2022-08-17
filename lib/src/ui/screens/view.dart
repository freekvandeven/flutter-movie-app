import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:movie_viewing_app/src/ui/widgets/icon_button.dart';

class MovieViewScreen extends ConsumerStatefulWidget {
  const MovieViewScreen({
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState<MovieViewScreen> createState() => _MovieViewScreenState();
}

class _MovieViewScreenState extends ConsumerState<MovieViewScreen> {
  late MovieUserSettings _settings;
  late Movie _movie;
  late Timer _timer;
  int minutesPlayed = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _settings = ref
        .read(movieSettingsProvider)
        .firstWhere((element) => element.selected);
    _movie = ref
        .read(movieCatalogueProvider)
        .firstWhere((element) => element.title == _settings.title);

    // start timer to update time watched every minute
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      minutesPlayed++;
      ref.read(movieSettingsProvider.notifier).updateMovieUserSettings(
            _settings.copyWith(timeWatched: minutesPlayed),
          );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              top: MediaQuery.of(context).size.height * 0.015,
              bottom: MediaQuery.of(context).size.height * 0.03,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      onTap: (_) {
                        Navigator.of(context).pop();
                      },
                      icon: Icons.close_rounded,
                    ),
                    CustomIconButton(
                      onTap: (_) {
                        debugPrint('open video settings');
                      },
                      icon: Icons.settings_outlined,
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    children: [
                      CustomIconButton(
                        onTap: (_) {
                          debugPrint('Change video quality');
                        },
                        icon: Icons.high_quality_outlined,
                      ),
                      CustomIconButton(
                        onTap: (_) {
                          debugPrint('Toggle closed caption');
                        },
                        icon: Icons.closed_caption_outlined,
                      ),
                      // video progress bar
                      Expanded(
                        child: Slider(
                          value: _settings.timeWatched / _movie.duration,
                          onChanged: (value) {
                            debugPrint('Video progress: $value');
                          },
                          inactiveColor: Colors.red,
                          activeColor: Colors.blue,
                        ),
                      ),
                      CustomIconButton(
                        onTap: (_) {
                          debugPrint('Open flutter app in android window');
                        },
                        icon: Icons.expand,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:floating/floating.dart';
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
  final Floating floating = Floating();
  late MovieUserSettings _settings;
  late Movie _movie;
  late Timer _timer;
  int secondsPlayed = 0;

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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsPlayed += 60;
      if (secondsPlayed + _settings.timeWatched >= _movie.duration) {
        secondsPlayed = -1 * _settings.timeWatched;
      }
      ref.read(movieSettingsProvider.notifier).updateMovieUserSettings(
            _settings.copyWith(
              timeWatched: _settings.timeWatched + secondsPlayed,
            ),
          );
      setState(() {});
    });
  }

  @override
  void dispose() {
    floating.dispose();
    _timer.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> enablePip() async {
    var status = await floating.enable(const Rational.landscape());
    debugPrint('PiP enabled? $status');
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
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icons.close_rounded,
                    ),
                    CustomIconButton(
                      onTap: () {
                        debugPrint('open video settings');
                      },
                      icon: Icons.settings_outlined,
                    ),
                  ],
                ),
                DecoratedBox(
                  // grey background with a bit of transparancy
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                  child: Row(
                    children: [
                      CustomIconButton(
                        onTap: () {
                          debugPrint('Change video quality');
                        },
                        icon: Icons.high_quality_outlined,
                      ),
                      CustomIconButton(
                        onTap: () {
                          debugPrint('Toggle closed caption');
                        },
                        icon: Icons.closed_caption_outlined,
                      ),
                      // video progress bar
                      Expanded(
                        child: Slider(
                          value: (_settings.timeWatched + secondsPlayed) /
                              _movie.duration,
                          onChanged: (value) {
                            debugPrint('Video progress: $value');
                          },
                          inactiveColor: Colors.red,
                          activeColor: Colors.blue,
                        ),
                      ),
                      CustomIconButton(
                        onTap: () {
                          debugPrint('Open flutter app in android window');

                          // TODO(freek): Add message or alternative for iOS
                        },
                        icon: Icons.expand,
                      ),
                      PiPSwitcher(
                        childWhenEnabled: CustomIconButton(
                          onTap: () {},
                          icon: Icons.expand_outlined,
                        ),
                        childWhenDisabled: CustomIconButton(
                          onTap: enablePip,
                          icon: Icons.picture_in_picture,
                        ),
                        floating: floating,
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

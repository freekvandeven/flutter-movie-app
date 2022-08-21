import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:movie_viewing_app/src/ui/widgets/actor_card.dart';
import 'package:movie_viewing_app/src/ui/widgets/genre_card.dart';
import 'package:movie_viewing_app/src/ui/widgets/icon_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  const MovieDetailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late Movie _movie;
  late MovieUserSettings _movieSettings;
  bool _playerEnabled = true;
  bool _isPlaying = false;
  late YoutubePlayerController _controller;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  bool _secondAnimation = false;

  @override
  void initState() {
    super.initState();
    _playerEnabled = ref.read(configServiceProvider).trailersEnabled;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.decelerate),
    )..addListener(() {
        // once the animation is done, set the second animation to true
        if (_animation.status == AnimationStatus.completed &&
            !_secondAnimation) {
          _secondAnimation = true;
          _animationController
            ..reset()
            ..forward();
        }
        setState(() {});
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(_movie.trailer) ?? '',
        flags: const YoutubePlayerFlags(
          hideThumbnail: true,
          autoPlay: true,
          mute: true,
          hideControls: true,
          enableCaption: false,
          loop: true,
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onPageExit(MovieUserSettings settings) async {
    await ref
        .read(movieSettingsProvider.notifier)
        .updateMovieUserSettings(settings.copyWith(selected: false));
  }

  @override
  Widget build(BuildContext context) {
    var settings =
        ref.watch(movieSettingsProvider).where((element) => element.selected);
    if (settings.isEmpty) {
      return Container();
    } else {
      _movieSettings = settings.first;
    }
    _movie = ref
        .read(movieCatalogueProvider)
        .firstWhere((element) => element.title == _movieSettings.title);

    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () async {
        await _onPageExit(_movieSettings);
        return true;
      },
      child: BaseScreen(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // show movie poster for the first few seconds
                  Stack(
                    children: [
                      if (_playerEnabled) ...[
                        YoutubePlayer(
                          onReady: () {
                            Future.delayed(const Duration(seconds: 5), () {
                              if (mounted) {
                                setState(() {
                                  _isPlaying = true;
                                });
                              }
                            });
                          },
                          controller: _controller,
                        ),
                      ],
                      Opacity(
                        opacity: _isPlaying ? 0 : 0.99,
                        child: SizedBox(
                          width: size.width,
                          height: size.height * 0.30,
                          child: Image.asset(
                            _movie.descriptionImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: size.width * 0.7,
                            child: Text(
                              _movie.title,
                              style: textTheme.headline1!.copyWith(
                                fontSize: size.width * 0.08,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02,
                          ),
                          child: Row(
                            children: [
                              Text(
                                // replace . with ,
                                _movie.rating.toStringAsFixed(1).replaceAll(
                                      '.',
                                      ',',
                                    ),
                                style: textTheme.headline4,
                              ),
                              Icon(
                                Icons.star_rate_rounded,
                                color: textTheme.headline4!.color,
                              ),
                              Text(
                                ' · ',
                                style: textTheme.headline4!.copyWith(
                                  fontSize: size.width * 0.06,
                                ),
                              ),
                              Text(
                                '${_movie.duration ~/ 3600}h '
                                '${_movie.duration % 3600 ~/ 60} min',
                                style: textTheme.headline4,
                              ),
                              Text(
                                ' · ',
                                style: textTheme.headline4!.copyWith(
                                  fontSize: size.width * 0.06,
                                ),
                              ),
                              Text(
                                _movie.year.toString(),
                                style: textTheme.headline4,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            for (var genre in _movie.genres) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                  right: size.width * 0.01,
                                ),
                                child: GenreCard(title: genre),
                              ),
                            ],
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.04,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    // pause the trailer
                                    _controller.pause();
                                    var result =
                                        await Navigator.of(context).pushNamed(
                                      MovieRoute.movieView.route,
                                    );
                                    if (result != null) {
                                      // resume the trailer
                                      _controller.play();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.008,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // play button
                                        Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: size.width * 0.09,
                                        ),
                                        Text(
                                          _movieSettings.timeWatched <= 0
                                              ? 'Watch movie'
                                              : 'Continue watching',
                                          style: textTheme.headline5!.copyWith(
                                            fontSize: size.width * 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.04,
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                    // grey border around the button
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                        255,
                                        114,
                                        109,
                                        109,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    iconSize: size.width * 0.07,
                                    icon: const Icon(
                                      Icons.file_download_outlined,
                                    ),
                                  ),
                                ),
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  // grey border around the button
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      114,
                                      109,
                                      109,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  iconSize: size.width * 0.07,
                                  onPressed: () {
                                    Share.share(
                                      _movie.trailer,
                                      subject: 'New Movie you should watch',
                                    );
                                  },
                                  icon: const Icon(Icons.share_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // actors list
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Opacity(
                            opacity:
                                (!_secondAnimation && _animation.value <= 1)
                                    ? _animation.value
                                    : 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: (!_secondAnimation &&
                                          _animation.value <= 1)
                                      ? size.width *
                                          0.6 *
                                          (1 - _animation.value)
                                      : 0,
                                ),
                                for (var actor in _movie.actors) ...[
                                  ActorCard(
                                    padding: size.height * 0.01,
                                    role: actor,
                                    actor: ref.read(actorProvider).firstWhere(
                                          (element) =>
                                              element.name == actor.name,
                                        ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: (!_secondAnimation)
                              ? 0
                              : (_animation.value <= 1)
                                  ? _animation.value
                                  : 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.08 -
                                  _animation.value * size.height * 0.04,
                              bottom: size.height * 0.02,
                            ),
                            child: Text(
                              _movie.description,
                              style: textTheme.bodyText1!.copyWith(
                                height: 1.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // backbutton
                  CustomIconButton(
                    size: size.width * 0.04,
                    alpha: 60,
                    blurFactor: 0.01,
                    iconScale: 2.2,
                    icon: Icons.chevron_left_rounded,
                    onTap: () async {
                      var navigator = Navigator.of(context);
                      await _onPageExit(_movieSettings);
                      navigator.pop();
                    },
                  ),
                  // likebutton
                  CustomIconButton(
                    size: size.width * 0.03,
                    alpha: _movieSettings.favorite ? 100 : 70,
                    blurFactor: 0.01,
                    iconScale: 2.2,
                    icon: _movieSettings.favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    onTap: () {
                      ref
                          .read(movieSettingsProvider.notifier)
                          .updateMovieUserSettings(
                            _movieSettings.copyWith(
                              favorite: !_movieSettings.favorite,
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

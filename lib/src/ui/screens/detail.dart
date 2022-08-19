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

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  late Movie movie;
  late MovieUserSettings movieSettings;
  bool playerEnabled = true;
  bool isPlaying = false;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    playerEnabled = ref.read(configServiceProvider).trailersEnabled;
  }

  Future<void> _onPageExit(MovieUserSettings settings) async {
    await ref
        .read(movieSettingsProvider.notifier)
        .updateMovieUserSettings(settings.copyWith(selected: false));
  }

  @override
  Widget build(BuildContext context) {
    // prevent Bad State during settings update and screen pop
    var settings =
        ref.watch(movieSettingsProvider).where((element) => element.selected);
    if (settings.isEmpty) {
      return Container();
    } else {
      movieSettings = settings.first;
    }
    movie = ref
        .read(movieCatalogueProvider)
        .firstWhere((element) => element.title == movieSettings.title);
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(movie.trailer) ?? '',
      flags: const YoutubePlayerFlags(
        startAt: 1,
        hideThumbnail: true,
        autoPlay: true,
        mute: true,
        hideControls: true,
        enableCaption: false,
        loop: true,
      ),
    );
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () async {
        await _onPageExit(movieSettings);
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
                      if (playerEnabled) ...[
                        YoutubePlayer(
                          onReady: () {
                            Future.delayed(const Duration(seconds: 4), () {
                              if (mounted) {
                                setState(() {
                                  isPlaying = true;
                                });
                              }
                            });
                          },
                          controller: _controller,
                        ),
                      ],
                      Opacity(
                        opacity: isPlaying ? 0 : 0.99,
                        child: SizedBox(
                          width: size.width,
                          height: size.height * 0.30,
                          child: Image.asset(
                            movie.descriptionImage,
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
                        Text(
                          movie.title,
                          style: textTheme.headline3,
                        ),
                        Row(
                          children: [
                            Text(
                              movie.rating.toString(),
                              style: textTheme.headline4,
                            ),
                            Icon(
                              Icons.star,
                              color: textTheme.headline4!.color,
                            ),
                            // dot in the middle of the text
                            Text(
                              '·',
                              style: textTheme.headline4,
                            ),
                            Text(
                              '${movie.duration ~/ 3600}h '
                              '${movie.duration % 3600 ~/ 60} min',
                              style: textTheme.headline4,
                            ),
                            Text(
                              '·',
                              style: textTheme.headline4,
                            ),
                            Text(
                              movie.year.toString(),
                              style: textTheme.headline4,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            for (var genre in movie.genres) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                  right: size.width * 0.01,
                                ),
                                child: GenreCard(title: genre),
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // pause the trailer
                                _controller.pause();
                                var result =
                                    await Navigator.of(context).pushNamed(
                                  MovieRoute.movieView.route,
                                );
                                if (result != null) {
                                  // resume the trailer
                                  // _controller.play();
                                  debugPrint('result: $result');
                                }
                              },
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Row(
                                  children: [
                                    // play button
                                    const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      movieSettings.timeWatched <= 0
                                          ? 'Watch movie'
                                          : 'Continue watching',
                                      style: textTheme.headline5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                debugPrint('download movie');
                              },
                              icon: const Icon(Icons.file_download_outlined),
                            ),
                            IconButton(
                              onPressed: () {
                                Share.share(
                                  movie.trailer,
                                  subject: 'New Movie you should watch',
                                );
                              },
                              icon: const Icon(Icons.share),
                            ),
                          ],
                        ),

                        // actors list
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var actor in movie.actors) ...[
                                ActorCard(
                                  role: actor,
                                  actor: ref.read(actorProvider).firstWhere(
                                        (element) => element.name == actor.name,
                                      ),
                                )
                              ]
                            ],
                          ),
                        ),

                        Text(
                          movie.description,
                          style: textTheme.bodyText1,
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
                vertical: 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // backbutton
                  CustomIconButton(
                    size: 10,
                    icon: Icons.chevron_left,
                    onTap: () async {
                      var navigator = Navigator.of(context);
                      await _onPageExit(movieSettings);
                      navigator.pop();
                    },
                  ),
                  // likebutton
                  CustomIconButton(
                    size: 10,
                    icon: movieSettings.favorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    onTap: () {
                      ref
                          .read(movieSettingsProvider.notifier)
                          .updateMovieUserSettings(
                            movieSettings.copyWith(
                              favorite: !movieSettings.favorite,
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

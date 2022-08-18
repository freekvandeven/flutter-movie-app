import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
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

  @override
  void initState() {
    super.initState();
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
                  if (playerEnabled) ...[
                    // show movie poster for the first few seconds
                    Stack(
                      children: [
                        YoutubePlayer(
                          onReady: () {
                            Future.delayed(const Duration(seconds: 4), () {
                              setState(() {
                                isPlaying = true;
                              });
                            });
                          },
                          controller: YoutubePlayerController(
                            initialVideoId:
                                YoutubePlayer.convertUrlToId(movie.trailer) ??
                                    '',
                            flags: const YoutubePlayerFlags(
                              startAt: 1,
                              hideThumbnail: true,
                              autoPlay: true,
                              mute: true,
                              hideControls: true,
                              enableCaption: false,
                              loop: true,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: isPlaying ? 0 : 0.98,
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
                  ] else ...[
                    SizedBox(
                      height: size.height * 0.3,
                    ),
                  ],
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
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            MovieRoute.movieView.route,
                          );
                        },
                        child: Container(
                          child: Text(
                            movieSettings.timeWatched <= 0
                                ? 'Watch movie'
                                : 'Continue watching',
                            style: textTheme.headline5,
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
                          debugPrint('share movie link');
                          Share.share(
                            movie.trailer,
                            subject: 'New Movie you should watch',
                          );
                        },
                        icon: const Icon(Icons.share),
                      ),
                    ],
                  ),

                  // actors row

                  Text(
                    movie.description,
                    style: textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // backbutton
                CustomIconButton(
                  icon: Icons.chevron_left,
                  onTap: () async {
                    var navigator = Navigator.of(context);
                    await _onPageExit(movieSettings);
                    navigator.pop();
                  },
                ),
                // likebutton
                CustomIconButton(
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
          ],
        ),
      ),
    );
  }
}

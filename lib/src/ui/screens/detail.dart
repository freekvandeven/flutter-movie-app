import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  const MovieDetailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  late Movie movie;
  late MovieUserSettings movieSettings;

  @override
  void initState() {
    movieSettings = ref
        .read(movieSettingsProvider)
        .firstWhere((element) => element.selected);
    movie = ref
        .read(movieCatalogueProvider)
        .firstWhere((element) => element.title == movieSettings.title);
    super.initState();
  }

  Future<void> _onPageExit() async {
    await ref
        .read(movieSettingsProvider.notifier)
        .updateMovieUserSettings(movieSettings.copyWith(selected: false));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        await _onPageExit();
        return true;
      },
      child: BaseScreen(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.3,
                  ),
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Row(
                    children: [
                      Text(
                        movie.rating.toString(),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Icon(
                        Icons.star,
                        color: Theme.of(context).textTheme.headline4!.color,
                      ),
                      // dot in the middle of the text
                      const Text('·'),
                      Text(
                        '${movie.duration ~/ 60}h ${movie.duration % 60} min',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const Text('·'),
                      Text(
                        movie.year.toString(),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      for (var genre in movie.genres) ...[
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Text(
                            genre,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            MovieRoute.movieDetail.route,
                          );
                        },
                        child: Container(
                          child: Text(
                            'Watch movie',
                            style: Theme.of(context).textTheme.headline5,
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
                        },
                        icon: const Icon(Icons.share),
                      ),
                    ],
                  ),

                  // actors row

                  Text(
                    movie.description,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // backbutton
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () async {
                    var navigator = Navigator.of(context);
                    await _onPageExit();
                    navigator.pop();
                  },
                ),
                // likebutton
                IconButton(
                  icon: Icon(
                    movieSettings.favorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: () {
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

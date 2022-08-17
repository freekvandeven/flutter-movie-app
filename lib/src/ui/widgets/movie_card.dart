import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/providers.dart';

class MovieCard extends ConsumerWidget {
  const MovieCard({
    required this.movie,
    required this.settings,
    this.onTap,
    Key? key,
  }) : super(key: key);
  final Movie movie;
  final MovieUserSettings settings;
  final Function(BuildContext)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        debugPrint('card tapped');
        // update the moviesetting to selected
        ref.read(movieSettingsProvider.notifier).updateMovieUserSettings(
              settings.copyWith(selected: true),
            );
        onTap?.call(context);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.green,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  // favorite the movie
                  ref
                      .read(movieSettingsProvider.notifier)
                      .updateMovieUserSettings(
                        settings.copyWith(
                          favorite: !settings.favorite,
                        ),
                      );
                },
                icon: Icon(
                  settings.favorite ? Icons.favorite : Icons.favorite_outline,
                  size: size.width * 0.05,
                ),
              ),
            ),
            DecoratedBox(
              // add blur to the container to see image behind
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                  vertical: size.height * 0.015,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        // TODO(freek): replace . with a ,
                        const Spacer(),
                        Text(
                          movie.rating.toString(),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        // yellow star icon
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: size.width * 0.05,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (var genre in movie.genres) ...[
                          Padding(
                            padding: EdgeInsets.only(
                              right: size.width * 0.01,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02,
                                vertical: size.height * 0.002,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                genre,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
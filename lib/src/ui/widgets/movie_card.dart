import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/widgets/genre_card.dart';
import 'package:movie_viewing_app/src/ui/widgets/icon_button.dart';
import 'package:movie_viewing_app/src/ui/widgets/rotate_card.dart';

class MovieCard extends ConsumerWidget {
  const MovieCard({
    required this.movie,
    required this.settings,
    this.onTap,
    this.rotatable = false,
    this.scale = 1.0,
    Key? key,
  }) : super(key: key);

  final Movie movie;
  final MovieUserSettings settings;
  final Function(BuildContext)? onTap;
  final bool rotatable;
  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(freek): create a different layout when movie has already been played
    var size = MediaQuery.of(context).size;
    var content = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // update the moviesetting to selected
        ref.read(movieSettingsProvider.notifier).updateMovieUserSettings(
              settings.copyWith(selected: true),
            );

        onTap?.call(context);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(movie.bannerImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CustomIconButton(
                onTap: () {
                  // favorite the movie
                  ref
                      .read(movieSettingsProvider.notifier)
                      .updateMovieUserSettings(
                        settings.copyWith(
                          favorite: !settings.favorite,
                        ),
                      );
                },
                icon:
                    settings.favorite ? Icons.favorite : Icons.favorite_outline,
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
                        SizedBox(
                          width: size.width * 0.35,
                          child: Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline5,
                          ),
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
                            child: GenreCard(title: genre),
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
    return rotatable ? RotateCardWidget(child: content) : content;
  }
}

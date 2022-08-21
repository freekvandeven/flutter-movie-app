import 'dart:ui';

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
              child: Padding(
                padding: EdgeInsets.only(
                  right: size.width * 0.02 * scale,
                  top: size.height * 0.015 * scale,
                ),
                child: CustomIconButton(
                  size: size.width * 0.03,
                  alpha: settings.favorite ? 100 : 70,
                  blurFactor: 0.01,
                  iconScale: 2.2,
                  onTap: () {
                    ref
                        .read(movieSettingsProvider.notifier)
                        .updateMovieUserSettings(
                          settings.copyWith(
                            favorite: !settings.favorite,
                          ),
                        );
                  },
                  icon: settings.favorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                ),
              ),
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              // add blur to the container to see image behind
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.white.withOpacity(0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: size.width * 0.015,
                  sigmaY: size.width * 0.015,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02 * scale,
                    vertical: size.height * 0.015 * scale,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: size.height * 0.01 * scale),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                movie.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      fontSize: size.width * 0.04 * scale,
                                    ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  // replace . with , in movie rating
                                  movie.rating.toString().replaceAll(
                                        RegExp(r'\.'),
                                        ',',
                                      ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        fontSize: size.width * 0.04 * scale,
                                      ),
                                ),
                                Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.yellow,
                                  size: size.width * 0.05 * scale,
                                ),
                              ],
                            ),
                            // yellow star icon
                          ],
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: size.width * 0.008,
                        runSpacing: size.height * 0.005,
                        children: [
                          for (var genre in movie.genres) ...[
                            GenreCard(title: genre),
                          ],
                        ],
                      ),
                    ],
                  ),
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

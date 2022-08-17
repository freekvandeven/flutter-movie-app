import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/movie_settings.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:movie_viewing_app/src/ui/widgets/icon_button.dart';
import 'package:movie_viewing_app/src/ui/widgets/movie_card.dart';
import 'package:movie_viewing_app/src/ui/widgets/premium_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var movieSettings = ref.watch(movieSettingsProvider);
    var movies = ref.watch(movieCatalogueProvider);
    return BaseScreen(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: size.height * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PremiumCard(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(
                        'View all',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * 0.5,
                  height: size.height * 0.4,
                  child: MovieCard(
                    onTap: (context) {
                      Navigator.of(context)
                          .pushNamed(MovieRoute.movieDetail.route);
                    },
                    movie: movies.first,
                    settings: movieSettings.firstWhere(
                      (element) => element.title == movies.first.title,
                      orElse: () =>
                          MovieUserSettings.defaultSettings(movies.first.title),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'New',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              'View all',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: size.height * 0.03,
                        crossAxisSpacing: size.width * 0.05,
                        children: movies
                            .where((element) => element.upcoming)
                            .take(8)
                            .map(
                              (movie) => MovieCard(
                                onTap: (context) {
                                  Navigator.of(context).pushNamed(
                                    MovieRoute.movieDetail.route,
                                  );
                                },
                                movie: movie,
                                settings: movieSettings.firstWhere(
                                  (element) => element.title == movie.title,
                                  orElse: () =>
                                      MovieUserSettings.defaultSettings(
                                    movie.title,
                                  ),
                                ),
                              ),
                            ) // only first 8 items in the list are shown
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: size.height * 0.1, // topbar height
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // profile button
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  CustomIconButton(onTap: (_) {}, icon: Icons.menu),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

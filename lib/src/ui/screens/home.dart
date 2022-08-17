import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/movie_settings.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:movie_viewing_app/src/ui/widgets/movie_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  bool _watchFavoriteDismissed = false;
  late AnimationController _fadeController;
  bool _shrinkingBox = false;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        setState(() {});
      });
    scaleAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );
    super.initState();
  }

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
                if (!_shrinkingBox) ...[
                  SizedBox(
                    height: size.height * 0.15,
                    child: AnimatedOpacity(
                      curve: Curves.easeIn,
                      opacity: _watchFavoriteDismissed ? 0.0 : 1.0,
                      onEnd: () {
                        _fadeController.forward();
                        _shrinkingBox = true;
                      },
                      duration: const Duration(milliseconds: 400),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                            vertical: size.height * 0.01,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 10.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Watch favorite movies '
                                        '\nwithout any ads',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      const Spacer(),
                                      // dismiss button
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          setState(() {
                                            _watchFavoriteDismissed = true;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Get premium',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    height: size.height * 0.15 * scaleAnimation.value,
                  ),
                ],
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
                const SizedBox(
                  height: 100,
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
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: movies
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
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: size.height * 0.1,
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
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

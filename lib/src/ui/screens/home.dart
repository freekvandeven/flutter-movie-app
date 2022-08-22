import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:movie_viewing_app/src/ui/widgets/icon_button.dart';
import 'package:movie_viewing_app/src/ui/widgets/movie_card.dart';
import 'package:movie_viewing_app/src/ui/widgets/premium_card.dart';
import 'package:movie_viewing_app/src/ui/widgets/quick.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController pageController = PageController(
    initialPage: 1000,
    viewportFraction: 0.5,
  );
  double _currentPage = 1000;
  int previousPage = 999;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var movieSettings = ref.watch(movieSettingsProvider);
    var movies = ref.watch(movieCatalogueProvider);
    return QuickActionsWidget(
      child: BaseScreen(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(top: size.height * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PremiumCard(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          'View all',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.4,
                    child: PageView.builder(
                      controller: pageController,
                      itemBuilder: (context, index) {
                        var movie = movies[index % movies.length];
                        return AnimatedBuilder(
                          animation: pageController,
                          builder: (context, child) {
                            var page = _currentPage;
                            var value = index - page;
                            var rotation = value * 0.25;
                            return Transform.rotate(
                              angle: rotation,
                              child: child,
                            );
                          },
                          child: MovieCard(
                            rotatable: index == _currentPage &&
                                ref
                                    .read(configServiceProvider)
                                    .rotateSliderCards,
                            // TODO(freek): remove when rotatable is implemented
                            textAnimation: (index == _currentPage) ? 1.0 : 0.0,
                            movie: movie,
                            settings: movieSettings.firstWhere(
                              (element) => element.title == movie.title,
                              orElse: () => MovieUserSettings.defaultSettings(
                                movie.title,
                              ),
                            ),
                            onTap: (context) {
                              Navigator.of(context)
                                  .pushNamed(MovieRoute.movieDetail.route);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      movies.length,
                      (index) => buildDot(index, movies),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'New',
                                style: Theme.of(context).textTheme.headline1,
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
                                  rotatable: false,
                                  textAnimation: 1.0,
                                  scale: 1.0,
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
                  SizedBox(
                    height: size.height * 0.05,
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
                    GestureDetector(
                      onTap: () async {
                        // update rotate card setting
                        var settings = ref.read(configServiceProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Rotate card '
                              '${!settings.rotateSliderCards ? 'on' : 'off'}',
                            ),
                          ),
                        );
                        await ref
                            .read(configServiceProvider.notifier)
                            .saveApplicationSettings(
                              settings.copyWith(
                                rotateSliderCards: !settings.rotateSliderCards,
                              ),
                            );
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/profile.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SizedBox(
                          width: size.width * 0.12,
                          height: size.width * 0.12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomIconButton(
                      size: size.width * 0.03,
                      iconScale: 2.2,
                      onTap: () async {
                        // TODO(freek): add menu for movie provider filtering
                        var scaffold = ScaffoldMessenger.of(context);
                        var currentSettings = ref.read(configServiceProvider);
                        await ref
                            .read(configServiceProvider.notifier)
                            .saveApplicationSettings(
                              currentSettings.copyWith(
                                trailersEnabled:
                                    !currentSettings.trailersEnabled,
                              ),
                            );
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(
                              'Trailers are '
                              '${currentSettings.trailersEnabled ? 'Y' : 'N'}',
                            ),
                          ),
                        );
                      },
                      icon: Icons.menu,
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

  Widget buildDot(int index, List<Movie> movies) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.015),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: MediaQuery.of(context).size.width * 0.015,
        width: (index == _currentPage.toInt() % movies.length)
            ? MediaQuery.of(context).size.width * 0.1
            : MediaQuery.of(context).size.width * 0.015,
        decoration: BoxDecoration(
          color: (index == _currentPage.toInt() % movies.length)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

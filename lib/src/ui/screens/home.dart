// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/movieroute.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:movie_viewing_app/src/ui/widgets/icon_button.dart';
import 'package:movie_viewing_app/src/ui/widgets/movie_card.dart';
import 'package:movie_viewing_app/src/ui/widgets/premium_card.dart';
import 'package:movie_viewing_app/src/ui/widgets/quick.dart';

class SelectedCard {
  const SelectedCard({
    required this.movie,
    required this.cardWidth,
    required this.cardHeight,
    required this.x,
    required this.y,
  });
  final Movie movie;
  final double cardWidth;
  final double cardHeight;
  final double x;
  final double y;
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController pageController = PageController(
    initialPage: 1000,
    viewportFraction: 0.5,
  );
  double _currentPage = 1000;
  int previousPage = 999;
  SelectedCard? _selectedCard;

  // card scale animation
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page!;
      });
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    )..addListener(() {
        // if the animation is finished route to the next screen
        if (_scaleAnimation.value >= 1 && _selectedCard != null) {
          _selectedCard = null;
          Navigator.of(context).pushNamed(
            MovieRoute.movieDetail.route,
          );
          _controller.reset();
        }

        setState(() {});
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
                        var key = GlobalKey();
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
                            key: key,
                            rotatable: index == _currentPage &&
                                ref
                                    .read(configServiceProvider)
                                    .rotateSliderCards,
                            textAnimation: (index == _currentPage) ? 1.0 : 0.0,
                            movie: movie,
                            settings: movieSettings.firstWhere(
                              (element) => element.title == movie.title,
                              orElse: () => MovieUserSettings.defaultSettings(
                                movie.title,
                              ),
                            ),
                            onTap: (context) {
                              _movieOnClick(key, movie);
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
                              .map((movie) {
                            var key = GlobalKey();
                            return MovieCard(
                              rotatable: false,
                              textAnimation: 1.0,
                              scale: 1.0,
                              key: key,
                              onTap: (context) {
                                _movieOnClick(key, movie);
                              },
                              movie: movie,
                              settings: movieSettings.firstWhere(
                                (element) => element.title == movie.title,
                                orElse: () => MovieUserSettings.defaultSettings(
                                  movie.title,
                                ),
                              ),
                            );
                          }) // only first 8 items in the list are shown
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

            // draw a movie card once it is selected
            if (_selectedCard != null)
              // center the card around an X and Y

              Positioned(
                top:
                    _selectedCard!.y - _scaleAnimation.value * _selectedCard!.y,
                left:
                    _selectedCard!.x - _scaleAnimation.value * _selectedCard!.x,
                child: SizedBox(
                  height: _selectedCard!.cardHeight +
                      _scaleAnimation.value *
                          (size.height - _selectedCard!.cardHeight),
                  width: _selectedCard!.cardWidth +
                      _scaleAnimation.value *
                          (size.width - _selectedCard!.cardWidth),
                  child: MovieCard(
                    scale: (_selectedCard!.cardWidth +
                            _scaleAnimation.value *
                                (size.width - _selectedCard!.cardWidth)) /
                        _selectedCard!.cardWidth,
                    textAnimation: 1.0,
                    movie: _selectedCard!.movie,
                    settings: movieSettings.firstWhere(
                      (element) => element.title == _selectedCard!.movie.title,
                      orElse: () => MovieUserSettings.defaultSettings(
                        _selectedCard!.movie.title,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _movieOnClick(GlobalKey<State<StatefulWidget>> key, Movie movie) {
    var box = key.currentContext!.findRenderObject()! as RenderBox;
    var position = box.localToGlobal(Offset.zero);
    setState(() {
      _selectedCard = SelectedCard(
        movie: movie,
        cardWidth: box.size.width,
        cardHeight: box.size.height,
        x: position.dx,
        y: position.dy,
      );
    });
    _controller.forward();
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

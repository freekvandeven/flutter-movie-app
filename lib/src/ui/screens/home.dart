import 'package:flutter/material.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:movie_viewing_app/src/models/movie_settings.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:movie_viewing_app/src/ui/widgets/movie_card.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  bool _watchFavoriteDismissed = false;
  final Vector3 _orientation = Vector3.zero();
  final Vector3 _baseOrientation = Vector3.zero();
  late AnimationController _fadeController;
  bool _shrinkingBox = false;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    ref.read(movieCatalogueProvider.notifier).fetchMovies();
    ref.read(actorProvider.notifier).fetchActors();
    ref.read(movieSettingsProvider.notifier).fetchMovieUserSettings();

    motionSensors.orientationUpdateInterval = 10;
    motionSensors.isOrientationAvailable().then((available) {
      if (available) {
        motionSensors.orientation.listen((OrientationEvent event) {
          if (_baseOrientation == Vector3.zero()) {
            _baseOrientation.setValues(event.yaw, event.pitch, event.roll);
          }
          setState(() {
            _orientation.setValues(event.yaw, event.pitch, event.roll);
          });
        });
      }
    });
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
                                  'Watch favorite movies \nwithout any ads',
                                  style: Theme.of(context).textTheme.headline5,
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
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Get premium',
                                  style: Theme.of(context).textTheme.headline5,
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
                Text('Popular', style: Theme.of(context).textTheme.headline3),
                Text('View all', style: Theme.of(context).textTheme.headline4),
              ],
            ),
          ),

          SizedBox(
            width: size.width * 0.5,
            height: size.height * 0.4,
            child: MovieCard(
              movie: movies.first,
              settings: movieSettings.firstWhere(
                (element) => element.title == movies.first.title,
                orElse: () =>
                    MovieUserSettings.defaultSettings(movies.first.title),
              ),
            ),
          ),
          // make a scrollable list of movies with cards
          // that contain the movie poster and title

          // const SizedBox(
          //   height: 100,
          // ),
          // Transform(
          //   transform: Matrix4(
          //     1,
          //     0,
          //     0,
          //     0,
          //     0,
          //     1,
          //     0,
          //     0,
          //     0,
          //     0,
          //     1,
          //     0,
          //     0,
          //     0,
          //     0,
          //     1,
          //   )
          //     ..rotateY(-_orientation.z)
          //     ..rotateX(-(_orientation.x - _baseOrientation.x)),
          //   alignment: FractionalOffset.center,
          //   child: Text(
          //     'Thomb Rider',
          //     style: Theme.of(context).textTheme.headline3,
          //   ),
          // ),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('New', style: Theme.of(context).textTheme.headline3),
                    Text(
                      'View all',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
                // make a gridview of movie cards 2 wide
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _watchFavoriteDismissed = false;
  final Vector3 _orientation = Vector3.zero();
  final Vector3 _baseOrientation = Vector3.zero();

  @override
  void initState() {
    motionSensors.orientationUpdateInterval = 60;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BaseScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_watchFavoriteDismissed) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Watch favorite movies\n without any ads',
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
                          borderRadius: BorderRadius.circular(20),
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
          const SizedBox(
            height: 100,
          ),
          Transform(
            transform: Matrix4(
              1,
              0,
              0,
              0,
              0,
              1,
              0,
              0,
              0,
              0,
              1,
              0,
              0,
              0,
              0,
              1,
            )
              ..rotateY(-_orientation.z)
              ..rotateX(-(_orientation.x - _baseOrientation.x)),
            alignment: FractionalOffset.center,
            child: Text(
              'Thomb Rider',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Gyroscope: ${_orientation.y}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

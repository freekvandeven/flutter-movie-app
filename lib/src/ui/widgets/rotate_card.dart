import 'package:flutter/material.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class RotateCardWidget extends StatefulWidget {
  const RotateCardWidget({required this.child, Key? key}) : super(key: key);

  final Widget child;
  @override
  State<RotateCardWidget> createState() => _RotateCardWidgetState();
}

class _RotateCardWidgetState extends State<RotateCardWidget> {
  final Vector3 _orientation = Vector3.zero();
  final Vector3 _baseOrientation = Vector3.zero();
  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
    return widget.child;
  }
}

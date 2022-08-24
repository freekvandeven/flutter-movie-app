// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:async';

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
  StreamSubscription<OrientationEvent>? _orientationSubscription;

  @override
  void initState() {
    super.initState();
    motionSensors.isOrientationAvailable().then((available) {
      if (available) {
        _orientationSubscription =
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
  }

  @override
  void dispose() {
    // dispose the controller when the widget is disposed
    _orientationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..rotateY(-_orientation.z)
        // move the X slightly up on the opposite axis of the y rotation
        ..rotateZ(-_orientation.z / 16),
      alignment: FractionalOffset.center,
      child: widget.child,
    );
  }
}

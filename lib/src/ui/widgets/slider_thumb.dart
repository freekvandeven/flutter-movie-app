// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';

class PointyCircleThumbShape extends SliderComponentShape {
  const PointyCircleThumbShape({
    required this.thumbRadius,
    required this.sliderBarSize,
  });
  final double thumbRadius;
  final double sliderBarSize;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    var canvas = context.canvas;

    var fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    // draw the circle with an offset by the half the sliderbar
    canvas.drawCircle(
      center + Offset(0, -sliderBarSize / 2),
      thumbRadius,
      fillPaint,
    );
    // draw a white rectangle below the circle
    var rect = Rect.fromCenter(
      center: center,
      width: thumbRadius / 2,
      height: sliderBarSize + 1,
    );
    canvas.drawRect(rect, fillPaint);
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.onTap,
    required this.icon,
    required this.size,
    this.blurFactor = 0.003,
    this.iconScale = 1.8,
    this.alpha,
    Key? key,
  }) : super(key: key);

  final Function() onTap;
  final IconData icon;
  final double size;
  final double iconScale;
  final double blurFactor;

  final int? alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(alpha ?? 40),
        borderRadius: BorderRadius.circular(17),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: MediaQuery.of(context).size.width * blurFactor,
          sigmaY: MediaQuery.of(context).size.width * blurFactor,
        ),
        child: IconButton(
          padding: EdgeInsets.all(size / 2),
          onPressed: onTap,
          icon: Icon(
            icon,
            size: size * iconScale,
          ),
        ),
      ),
    );
  }
}

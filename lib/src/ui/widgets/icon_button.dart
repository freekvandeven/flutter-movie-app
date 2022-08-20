import 'dart:ui';

import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.onTap,
    required this.icon,
    required this.size,
    this.alpha,
    Key? key,
  }) : super(key: key);

  final Function() onTap;
  final IconData icon;
  final double size;
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
          sigmaX: MediaQuery.of(context).size.width * 0.003,
          sigmaY: MediaQuery.of(context).size.width * 0.003,
        ),
        child: IconButton(
          padding: EdgeInsets.all(size / 2),
          onPressed: onTap,
          icon: Icon(
            icon,
            size: size * 1.8,
          ),
        ),
      ),
    );
  }
}

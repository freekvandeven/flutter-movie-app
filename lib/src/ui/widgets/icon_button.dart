import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.onTap,
    required this.icon,
    required this.size,
    Key? key,
  }) : super(key: key);

  final Function() onTap;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(80),
        borderRadius: BorderRadius.circular(17),
      ),
      child: IconButton(
        padding: EdgeInsets.all(size / 2),
        onPressed: onTap,
        icon: Icon(
          icon,
          size: size * 1.8,
        ),
      ),
    );
  }
}

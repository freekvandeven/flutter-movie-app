import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.onTap,
    required this.icon,
    Key? key,
  }) : super(key: key);

  final Function(BuildContext) onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(80),
        borderRadius: BorderRadius.circular(17),
      ),
      child: IconButton(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
        onPressed: () => onTap,
        icon: Icon(icon),
      ),
    );
  }
}

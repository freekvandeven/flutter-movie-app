import 'package:flutter/material.dart';

class GenreCard extends StatelessWidget {
  const GenreCard({
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.016,
        vertical: MediaQuery.of(context).size.height * 0.004,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }
}

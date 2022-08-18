import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/models.dart';

class ActorCard extends StatelessWidget {
  const ActorCard({
    required this.role,
    required this.actor,
    Key? key,
  }) : super(key: key);
  final ActorInMovie role;
  final Actor actor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // TODO(freek): fetch image from internet of the actor
          Container(color: Colors.green),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  role.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  role.role,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

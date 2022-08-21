import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/models.dart';

class ActorCard extends StatelessWidget {
  const ActorCard({
    required this.role,
    required this.actor,
    required this.padding,
    Key? key,
  }) : super(key: key);
  final ActorInMovie role;
  final Actor actor;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(0.06),
          // light darkshadow going bottomright

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(5.0, 5.0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // TODO(freek): fetch image from internet of the actor
            // image of the actor
            Container(
              width: MediaQuery.of(context).size.width * 0.22,
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: AssetImage(actor.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.name,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  Text(
                    role.role,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

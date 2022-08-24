// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/ui/widgets/icon_button.dart';

class PremiumCard extends StatefulWidget {
  const PremiumCard({Key? key}) : super(key: key);

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard>
    with TickerProviderStateMixin {
  bool _watchFavoriteDismissed = false;
  late AnimationController _fadeController;
  bool _shrinkingBox = false;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        setState(() {});
      });
    scaleAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return !_shrinkingBox
        ? SizedBox(
            height: size.height * 0.17,
            child: AnimatedOpacity(
              curve: Curves.easeIn,
              opacity: _watchFavoriteDismissed ? 0.0 : 1.0,
              onEnd: () {
                _fadeController.forward();
                _shrinkingBox = true;
              },
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.01,
                ),
                child: DecoratedBox(
                  // add gradient from the left with color 1f3829
                  decoration: BoxDecoration(
                    // use background image premium.png as background
                    image: const DecorationImage(
                      image: AssetImage('assets/images/premium.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.015,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Watch favorite movies '
                              '\nwithout any ads',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            const Spacer(),
                            // dismiss button
                            CustomIconButton(
                              size: size.width * 0.04,
                              onTap: () {
                                setState(() {
                                  _watchFavoriteDismissed = true;
                                });
                              },
                              icon: Icons.close_rounded,
                            ),
                          ],
                        ),
                        const Spacer(),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.06,
                              vertical: size.height * 0.010,
                            ),
                            child: Text(
                              'Get premium',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : SizedBox(
            height: size.height * 0.17 * scaleAnimation.value,
          );
  }
}

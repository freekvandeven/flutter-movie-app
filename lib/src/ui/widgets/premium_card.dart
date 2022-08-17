import 'package:flutter/material.dart';

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
                  decoration: BoxDecoration(
                    color: Colors.blue,
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
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const Spacer(),
                            // dismiss button
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _watchFavoriteDismissed = true;
                                });
                              },
                            ),
                          ],
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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

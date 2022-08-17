import 'package:flutter/material.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  const MovieDetailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  late Movie movie;
  late MovieUserSettings movieSettings;

  @override
  void initState() {
    movieSettings = ref
        .read(movieSettingsProvider)
        .firstWhere((element) => element.selected);
    movie = ref
        .read(movieCatalogueProvider)
        .firstWhere((element) => element.title == movieSettings.title);
    super.initState();
  }

  Future<void> _onPageExit() async {
    await ref
        .read(movieSettingsProvider.notifier)
        .updateMovieUserSettings(movieSettings.copyWith(selected: false));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _onPageExit();
        return true;
      },
      child: BaseScreen(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // backbutton
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    var navigator = Navigator.of(context);
                    await _onPageExit();
                    navigator.pop();
                  },
                ),
                // likebutton
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {},
                ),
              ],
            ),
            Text(movie.title, style: Theme.of(context).textTheme.headline3),
          ],
        ),
      ),
    );
  }
}

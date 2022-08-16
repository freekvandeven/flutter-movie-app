import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieUserSettings {
  const MovieUserSettings({
    required this.title,
    required this.favorite,
    required this.timeWatched,
    required this.selected,
  });
  final String title;
  final bool favorite;
  final int timeWatched;
  final bool selected;
}

abstract class MovieService extends StateNotifier<List<MovieUserSettings>> {
  MovieService._() : super([]);

  Future<void> fetchMovieUserSettings();
  Future<void> updateMovieUserSettings(MovieUserSettings settings);
}

class LocalMovieService extends StateNotifier<List<MovieUserSettings>>
    implements MovieService {
  LocalMovieService() : super([]);
  @override
  Future<void> fetchMovieUserSettings() async {
    // get data from local storage
  }

  @override
  Future<void> updateMovieUserSettings(MovieUserSettings settings) async {
    state = state
        .map((movie) => movie.title == settings.title ? settings : movie)
        .toList();
  }
}

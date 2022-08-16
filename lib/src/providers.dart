import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_viewing_app/src/models/actor.dart';
import 'package:movie_viewing_app/src/models/movie.dart';
import 'package:movie_viewing_app/src/models/movie_settings.dart';
import 'package:movie_viewing_app/src/services/actor.dart';
import 'package:movie_viewing_app/src/services/catalogue.dart';
import 'package:movie_viewing_app/src/services/movie.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart';

final movieCatalogueProvider =
    StateNotifierProvider<MovieCatalogueService, List<Movie>>(
  (ref) => MockedMovieCatalogueService(),
);

final actorProvider = StateNotifierProvider<ActorService, List<Actor>>(
  (ref) => MockedActorService(),
);

final movieSettingsProvider =
    StateNotifierProvider<MovieService, List<MovieUserSettings>>(
  (ref) => LocalMovieService(),
);

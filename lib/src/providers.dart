import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/services/services.dart';

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

final configServiceProvider =
    StateNotifierProvider<ConfigService, ApplicationConfiguration>(
  (ref) => LocalConfigService(),
);

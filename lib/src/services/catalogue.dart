import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_viewing_app/src/models/movie.dart';

abstract class MovieCatalogueService extends StateNotifier<List<Movie>> {
  MovieCatalogueService._() : super(const []);
  Future<void> fetchMovies();
}

class MockedMovieCatalogueService extends StateNotifier<List<Movie>>
    implements MovieCatalogueService {
  MockedMovieCatalogueService() : super(const []);

  @override
  Future<void> fetchMovies() async {
    state = [
      const Movie(
        title: 'Fantastic beasts',
        description: '',
        image: 'assets/images/movies',
        video: 'assets/video',
        duration: 7400,
        year: 2022,
        genres: ['Fantastic', 'Action'],
        actors: [
          const ActorInMovie(
            role: 'Newt Scamander',
            name: 'Eddie Redmayne',
          ),
          const ActorInMovie(
            role: 'Albus Dumbledore',
            name: 'Jude Law',
          ),
        ],
        rating: 8.0,
      ),
    ];
  }
}

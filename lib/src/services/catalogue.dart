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
        title: 'Fantastic beasts: The Secrets of Dumbledore',
        description: 'Professor Albus Dumbledore must assign Newt Scamander '
            'and his fellow partners...',
        bannerImage: 'assets/images/movies/secrets_dumbledore.jpg',
        descriptionImage: 'assets/images/movies/secrets_dumbledore_detail.jpg',
        trailer: 'https://www.youtube.com/watch?v=Y9dr2zw-TXQ',
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
        popular: false,
        upcoming: true,
      ),
      const Movie(
        title: 'Tomb Raider',
        description: '',
        bannerImage: 'assets/images/movies/tomb_raider.jpg',
        descriptionImage: 'assets/images/movies',
        trailer: 'https://www.youtube.com/watch?v=8ndhidEmUbI',
        video: 'assets/video',
        duration: 7400,
        year: 2022,
        genres: [
          'Adventure',
          'Fantastic',
        ],
        actors: [
          const ActorInMovie(role: 'Newt Scamander', name: 'Eddie Redmayne'),
          const ActorInMovie(role: 'Albus Dumbledore', name: 'Jude Law')
        ],
        rating: 7.8,
        popular: true,
        upcoming: true,
      ),
      const Movie(
        title: 'Morbius',
        description: 'It\'s morbing time',
        bannerImage: 'assets/images/movies/morbius.jpg',
        descriptionImage: 'assets/images/movies',
        trailer: 'https://www.youtube.com/watch?v=oZ6iiRrz1SY',
        video: 'assets/video',
        duration: 7400,
        year: 2022,
        genres: ['Fantastic', 'Thriller'],
        actors: [
          const ActorInMovie(role: 'Newt Scamander', name: 'Eddie Redmayne'),
          const ActorInMovie(role: 'Albus Dumbledore', name: 'Jude Law')
        ],
        rating: 6.7,
        popular: true,
        upcoming: true,
      ),
      const Movie(
        title: 'Jungle cruise',
        description: '',
        bannerImage: 'assets/images/movies/jungle_cruise.jpeg',
        descriptionImage: '',
        trailer: 'https://www.youtube.com/watch?v=f_HvoipFcA8',
        video: '',
        duration: 7400,
        year: 2022,
        genres: [
          'Adventure',
          'Fantastic',
        ],
        actors: [],
        rating: 7.1,
        popular: true,
        upcoming: true,
      ),
    ];
  }
}

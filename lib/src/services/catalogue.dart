// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

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
        title: 'Fantastic Beasts: The Secrets of Dumbledore',
        description: 'Professor Albus Dumbledore must assign Newt Scamander '
            'and his fellow partners as Grindelwald begins to '
            'lead an army to eliminate all Muggles.',
        bannerImage: 'assets/images/movies/secrets_dumbledore.jpg',
        descriptionImage: 'assets/images/movies/secrets_dumbledore_detail.jpg',
        trailer: 'https://www.youtube.com/watch?v=Y9dr2zw-TXQ',
        video: 'https://www.freekvandeven.nl/streams/secrets_dumbledore.mp4',
        subtitleFile:
            'https://www.freekvandeven.nl/streams/secrets_dumbledore_english.srt',
        duration: 8559,
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
          const ActorInMovie(role: 'Grindelwald', name: 'Mads Mikkelsen'),
          const ActorInMovie(role: 'Jacob Kowalski', name: 'Dan Fogler'),
        ],
        rating: 6.2,
        popular: false,
        upcoming: true,
      ),
      const Movie(
        title: 'Tomb Raider',
        description: '',
        bannerImage: 'assets/images/movies/tomb_raider.jpg',
        descriptionImage: 'assets/images/movies/tomb_raider_detail.jpg',
        trailer: 'https://www.youtube.com/watch?v=8ndhidEmUbI',
        video: 'https://www.freekvandeven.nl/streams/tomb_raider.mp4',
        subtitleFile:
            'https://www.freekvandeven.nl/streams/tomb_raider_english.srt',
        duration: 7070,
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
        descriptionImage: 'assets/images/movies/morbius_detail.jpg',
        trailer: 'https://www.youtube.com/watch?v=oZ6iiRrz1SY',
        video: 'https://www.freekvandeven.nl/streams/morbius.mp4',
        subtitleFile:
            'https://www.freekvandeven.nl/streams/morbius_english.srt',
        duration: 6249,
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
        descriptionImage: 'assets/images/movies/jungle_cruise_detail.jpg',
        trailer: 'https://www.youtube.com/watch?v=f_HvoipFcA8',
        video: 'https://www.freekvandeven.nl/streams/jungle_cruise.mp4',
        subtitleFile:
            'https://www.freekvandeven.nl/streams/jungle_cruise_english.srt',
        duration: 7639,
        year: 2022,
        genres: [
          'Adventure',
          'Fantastic',
          'Action',
        ],
        actors: [],
        rating: 7.1,
        popular: true,
        upcoming: true,
      ),
    ];
  }
}

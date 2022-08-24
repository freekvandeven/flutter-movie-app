// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

class MovieRoute {
  const MovieRoute(this.route);

  static const splashScreen = MovieRoute('/splash');
  static const homeScreen = MovieRoute('/home');
  static const movieDetail = MovieRoute('/movie/detail');
  static const movieView = MovieRoute('/movie/view');

  final String route;

  @override
  String toString() => route;
}

class MovieRoute {
  const MovieRoute(this.route);

  static const homeScreen = MovieRoute('/home');
  static const movieDetail = MovieRoute('/movie/detail');
  static const movieView = MovieRoute('/movie/view');

  final String route;

  @override
  String toString() => route;
}

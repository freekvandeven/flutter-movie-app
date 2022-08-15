class MovieRoute {
  const MovieRoute(this.route);

  static const homeScreen = MovieRoute('/home');

  final String route;

  @override
  String toString() => route;
}

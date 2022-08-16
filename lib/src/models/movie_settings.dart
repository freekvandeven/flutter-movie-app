class MovieUserSettings {
  const MovieUserSettings({
    required this.title,
    required this.favorite,
    required this.timeWatched,
    required this.selected,
  });
  factory MovieUserSettings.fromJson(Map<String, dynamic> json) =>
      MovieUserSettings(
        title: json['title'] as String,
        favorite: json['favorite'] as bool,
        timeWatched: json['timeWatched'] as int,
        selected: json['selected'] as bool,
      );

  final String title;
  final bool favorite;
  final int timeWatched;
  final bool selected;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'favorite': favorite,
        'timeWatched': timeWatched,
        'selected': selected,
      };
}

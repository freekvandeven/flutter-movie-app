import 'package:flutter/material.dart';

class ActorInMovie {
  const ActorInMovie({
    required this.role,
    required this.name,
  });
  final String role;
  final String name;
  // TODO(freek): maybe use ID for actors and movies
}

@immutable
class Movie {
  const Movie({
    required this.title,
    required this.description,
    required this.bannerImage,
    required this.descriptionImage,
    required this.trailer,
    required this.video,
    required this.subtitleFile,
    required this.duration,
    required this.year,
    required this.genres,
    required this.actors,
    required this.rating,
    required this.popular,
    required this.upcoming,
  });
  final String title;
  final String description;
  final String bannerImage;
  final String descriptionImage;
  final String trailer;
  final String video;
  final String subtitleFile;
  final int duration;
  final int year;
  final List<String> genres;
  final List<ActorInMovie> actors;
  final double rating;
  final bool popular;
  final bool upcoming;
}

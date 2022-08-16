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
    required this.image,
    required this.video,
    required this.duration,
    required this.year,
    required this.genres,
    required this.actors,
    required this.rating,
  });
  final String title;
  final String description;
  final String image;
  final String video;
  final int duration;
  final int year;
  final List<String> genres;
  final List<ActorInMovie> actors;
  final double rating;
}

import 'package:flutter/material.dart';

@immutable
class Actor {
  const Actor({
    required this.name,
    required this.image,
  });
  final String name;
  final String image;
}

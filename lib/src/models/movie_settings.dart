// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';

@immutable
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
  factory MovieUserSettings.defaultSettings(String title) => MovieUserSettings(
        title: title,
        favorite: false,
        timeWatched: 0,
        selected: false,
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

  MovieUserSettings copyWith({
    String? title,
    bool? favorite,
    int? timeWatched,
    bool? selected,
  }) =>
      MovieUserSettings(
        title: title ?? this.title,
        favorite: favorite ?? this.favorite,
        timeWatched: timeWatched ?? this.timeWatched,
        selected: selected ?? this.selected,
      );
}

// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_viewing_app/src/models/movie_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MovieService extends StateNotifier<List<MovieUserSettings>> {
  MovieService._() : super([]);

  Future<void> fetchMovieUserSettings();
  Future<void> updateMovieUserSettings(MovieUserSettings settings);
}

class LocalMovieService extends StateNotifier<List<MovieUserSettings>>
    implements MovieService {
  LocalMovieService() : super([]);

  static final String movieUserSettingsKey = 'movie_user_settings';

  @override
  Future<void> fetchMovieUserSettings() async {
    // get data from local storage
    var prefs = await SharedPreferences.getInstance();
    var json = prefs.getString(movieUserSettingsKey);
    if (json == null) {
      return;
    }
    var settings = (jsonDecode(json) as List)
        .map((e) => MovieUserSettings.fromJson(e as Map<String, dynamic>))
        .toList();
    state = settings;
  }

  @override
  Future<void> updateMovieUserSettings(MovieUserSettings settings) async {
    if (!state.any((MovieUserSettings e) => e.title == settings.title)) {
      state = [
        ...state,
        settings,
      ];
    } else {
      state = state.map((e) {
        if (e.title == settings.title) {
          return settings;
        }
        return e;
      }).toList();
    }
    var prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(movieUserSettingsKey, json);
  }
}

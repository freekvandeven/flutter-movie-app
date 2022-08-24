// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ConfigService extends StateNotifier<ApplicationConfiguration> {
  ConfigService._() : super(ApplicationConfiguration.defaultConfiguration());

  Future<void> loadApplicationSettings();

  Future<void> saveApplicationSettings(ApplicationConfiguration config);
}

class LocalConfigService extends StateNotifier<ApplicationConfiguration>
    implements ConfigService {
  LocalConfigService() : super(ApplicationConfiguration.defaultConfiguration());

  static String settingsKey = 'settings';
  @override
  Future<void> loadApplicationSettings() async {
    var prefs = await SharedPreferences.getInstance();
    var settings = prefs.getString(settingsKey);
    if (settings != null) {
      var config = ApplicationConfiguration.fromJson(
        jsonDecode(settings),
      );
      state = config;
    }
  }

  @override
  Future<void> saveApplicationSettings(ApplicationConfiguration config) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(settingsKey, jsonEncode(config));
    state = config;
  }
}

// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';

@immutable
class ApplicationConfiguration {
  const ApplicationConfiguration({
    required this.trailersEnabled,
    required this.autoHideVideoControls,
    required this.closedCaptionsEnabled,
    required this.highQualityVideo,
    required this.rotateSliderCards,
    required this.movieVolume,
  });

  factory ApplicationConfiguration.fromJson(Map<String, dynamic> json) =>
      ApplicationConfiguration(
        trailersEnabled: json['trailersEnabled'],
        autoHideVideoControls: json['autoHideVideoControls'],
        closedCaptionsEnabled: json['closedCaptionsEnabled'],
        highQualityVideo: json['highQualityVideo'],
        rotateSliderCards: json['rotateSliderCards'],
        movieVolume: json['movieVolume'],
      );

  factory ApplicationConfiguration.defaultConfiguration() =>
      const ApplicationConfiguration(
        trailersEnabled: true,
        autoHideVideoControls: true,
        closedCaptionsEnabled: false,
        highQualityVideo: true,
        rotateSliderCards: true,
        movieVolume: 1.0,
      );

  final bool trailersEnabled;
  final bool autoHideVideoControls;
  final bool closedCaptionsEnabled;
  final bool highQualityVideo;
  final bool rotateSliderCards;
  final double movieVolume;

  Map<String, dynamic> toJson() {
    return {
      'trailersEnabled': trailersEnabled,
      'autoHideVideoControls': autoHideVideoControls,
      'closedCaptionsEnabled': closedCaptionsEnabled,
      'highQualityVideo': highQualityVideo,
      'rotateSliderCards': rotateSliderCards,
      'movieVolume': movieVolume,
    };
  }

  ApplicationConfiguration copyWith({
    bool? trailersEnabled,
    bool? autoHideVideoControls,
    bool? closedCaptionsEnabled,
    bool? highQualityVideo,
    bool? rotateSliderCards,
    double? movieVolume,
  }) =>
      ApplicationConfiguration(
        trailersEnabled: trailersEnabled ?? this.trailersEnabled,
        autoHideVideoControls:
            autoHideVideoControls ?? this.autoHideVideoControls,
        closedCaptionsEnabled:
            closedCaptionsEnabled ?? this.closedCaptionsEnabled,
        highQualityVideo: highQualityVideo ?? this.highQualityVideo,
        rotateSliderCards: rotateSliderCards ?? this.rotateSliderCards,
        movieVolume: movieVolume ?? this.movieVolume,
      );
}

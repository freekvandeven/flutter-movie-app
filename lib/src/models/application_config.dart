import 'package:flutter/material.dart';

@immutable
class ApplicationConfiguration {
  const ApplicationConfiguration({
    required this.trailersEnabled,
    required this.autoHideVideoControls,
    required this.closedCaptionsEnabled,
    required this.highQualityVideo,
    required this.movieVolume,
  });

  factory ApplicationConfiguration.fromJson(Map<String, dynamic> json) =>
      ApplicationConfiguration(
        trailersEnabled: json['trailersEnabled'],
        autoHideVideoControls: json['autoHideVideoControls'],
        closedCaptionsEnabled: json['closedCaptionsEnabled'],
        highQualityVideo: json['highQualityVideo'],
        movieVolume: json['movieVolume'],
      );

  factory ApplicationConfiguration.defaultConfiguration() =>
      const ApplicationConfiguration(
        trailersEnabled: true,
        autoHideVideoControls: true,
        closedCaptionsEnabled: false,
        highQualityVideo: true,
        movieVolume: 1.0,
      );

  final bool trailersEnabled;
  final bool autoHideVideoControls;
  final bool closedCaptionsEnabled;
  final bool highQualityVideo;
  final double movieVolume;

  Map<String, dynamic> toJson() {
    return {
      'trailersEnabled': trailersEnabled,
      'autoHideVideoControls': autoHideVideoControls,
      'closedCaptionsEnabled': closedCaptionsEnabled,
      'highQualityVideo': highQualityVideo,
      'movieVolume': movieVolume,
    };
  }

  ApplicationConfiguration copyWidth({
    bool? trailersEnabled,
    bool? autoHideVideoControls,
    bool? closedCaptionsEnabled,
    bool? highQualityVideo,
    double? movieVolume,
  }) =>
      ApplicationConfiguration(
        trailersEnabled: trailersEnabled ?? this.trailersEnabled,
        autoHideVideoControls:
            autoHideVideoControls ?? this.autoHideVideoControls,
        closedCaptionsEnabled:
            closedCaptionsEnabled ?? this.closedCaptionsEnabled,
        highQualityVideo: highQualityVideo ?? this.highQualityVideo,
        movieVolume: movieVolume ?? this.movieVolume,
      );
}

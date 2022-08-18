import 'package:flutter/material.dart';

@immutable
class ApplicationConfiguration {
  const ApplicationConfiguration({
    required this.trailersEnabled,
    required this.autoHideVideoControls,
  });

  factory ApplicationConfiguration.fromJson(Map<String, dynamic> json) =>
      ApplicationConfiguration(
        trailersEnabled: json['trailersEnabled'],
        autoHideVideoControls: json['autoHideVideoControls'],
      );

  factory ApplicationConfiguration.defaultConfiguration() =>
      const ApplicationConfiguration(
        trailersEnabled: true,
        autoHideVideoControls: true,
      );

  final bool trailersEnabled;
  final bool autoHideVideoControls;

  Map<String, dynamic> toJson() {
    return {
      'trailersEnabled': trailersEnabled,
      'autoHideVideoControls': autoHideVideoControls,
    };
  }
}

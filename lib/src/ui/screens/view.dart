// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_viewing_app/src/models/models.dart';
import 'package:movie_viewing_app/src/providers.dart';
import 'package:movie_viewing_app/src/ui/screens/base.dart';
import 'package:movie_viewing_app/src/ui/widgets/icon_button.dart';
import 'package:movie_viewing_app/src/ui/widgets/slider_thumb.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class MovieViewScreen extends ConsumerStatefulWidget {
  const MovieViewScreen({
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState<MovieViewScreen> createState() => _MovieViewScreenState();
}

class _MovieViewScreenState extends ConsumerState<MovieViewScreen> {
  final Floating _floating = Floating();
  bool _pipMode = false;
  bool _hideControls = false;
  bool _soundBarOpen = false;
  late MovieUserSettings _settings;
  late Movie _movie;
  late Timer _updateTimer;
  late Timer _controlHideTimer;
  int _secondsPlayed = 0;
  final int _timerUpdateInterval = 1;
  late VideoPlayerController? _videoController;

  // TODO(freek): add video sound control

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _settings = ref
        .read(movieSettingsProvider)
        .firstWhere((element) => element.selected);
    _movie = ref
        .read(movieCatalogueProvider)
        .firstWhere((element) => element.title == _settings.title);
    _secondsPlayed = _settings.timeWatched;

    _setVideoUpdateTimer();
    _initializeVideo();
    _setAutoHideTimer();
    Wakelock.enable();
  }

  @override
  void dispose() {
    Wakelock.disable();
    _videoController?.pause();
    _videoController?.dispose();
    _floating.dispose();
    _updateTimer.cancel();
    _controlHideTimer.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var iconSize = size.width * 0.02;
    var playTime =
        '${Movie.movieTimeAsString(_secondsPlayed)}/${Movie.movieTimeAsString(_movie.duration)}';
    var volume = ref.read(configServiceProvider).movieVolume;
    // TODO(freek): refactor this to pipstream to detect pip changes
    _checkPipEnabled();

    return BaseScreen(
      background: Colors.black,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _setAutoHideTimer,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _onVideoTap,
              child: (_videoController != null &&
                      _videoController!.value.isInitialized)
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : Container(
                      color: Theme.of(context).colorScheme.background,
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
                top: MediaQuery.of(context).size.height * 0.030,
                bottom: MediaQuery.of(context).size.height * 0.045,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (!_hideControls && !_pipMode) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          size: iconSize,
                          onTap: () => Navigator.of(context).pop(true),
                          icon: Icons.close_rounded,
                        ),
                        CustomIconButton(
                          size: iconSize,
                          onTap: () {
                            var config = ref.read(configServiceProvider);
                            var newConfig = config.copyWith(
                              autoHideVideoControls:
                                  !config.autoHideVideoControls,
                            );
                            ref
                                .read(configServiceProvider.notifier)
                                .saveApplicationSettings(
                                  newConfig,
                                );
                            // show a message to indicate the settings
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Auto hide video controls: '
                                  '${!config.autoHideVideoControls}',
                                ),
                              ),
                            );
                            if (newConfig.autoHideVideoControls) {
                              setState(() {
                                _hideControls = true;
                              });
                            }
                          },
                          icon: Icons.settings_outlined,
                        ),
                      ],
                    ),
                  ],
                  const Spacer(),
                  if (_videoController != null &&
                      ref
                          .read(configServiceProvider)
                          .closedCaptionsEnabled) ...[
                    ClosedCaption(
                      text: _videoController!.value.caption.text,
                      textStyle:
                          Theme.of(context).textTheme.headline4!.copyWith(
                                fontSize: size.width * 0.03,
                                color: Colors.white,
                              ),
                    ),
                  ],
                  if (!_hideControls && !_pipMode) ...[
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // white grey transparant background
                            color: const Color.fromARGB(255, 125, 122, 122)
                                .withOpacity(0.15),
                            // add blur effect
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: size.width * 0.008,
                              sigmaY: size.width * 0.008,
                            ),
                            // blendMode: BlendMode.srcOver,
                            child: Padding(
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.01,
                              ),
                              child: Row(
                                children: [
                                  CustomIconButton(
                                    alpha: ref
                                            .read(configServiceProvider)
                                            .highQualityVideo
                                        ? 100
                                        : null,
                                    size: iconSize,
                                    onTap: () {
                                      var config = ref.read(
                                        configServiceProvider,
                                      );
                                      ref
                                          .read(
                                            configServiceProvider.notifier,
                                          )
                                          .saveApplicationSettings(
                                            config.copyWith(
                                              highQualityVideo:
                                                  !config.highQualityVideo,
                                            ),
                                          );
                                    },
                                    icon: Icons.high_quality_outlined,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: size.width * 0.01,
                                    ),
                                    child: CustomIconButton(
                                      size: iconSize,
                                      alpha: ref
                                              .read(configServiceProvider)
                                              .closedCaptionsEnabled
                                          ? 100
                                          : null,
                                      onTap: () {
                                        var config =
                                            ref.read(configServiceProvider);
                                        ref
                                            .read(
                                              configServiceProvider.notifier,
                                            )
                                            .saveApplicationSettings(
                                              config.copyWith(
                                                closedCaptionsEnabled: !config
                                                    .closedCaptionsEnabled,
                                              ),
                                            );
                                      },
                                      icon: Icons.closed_caption_outlined,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: size.width * 0.01,
                                      right: size.width * 0.02,
                                    ),
                                    child: CustomIconButton(
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(seconds: 5), () {
                                          if (mounted) {
                                            setState(() {
                                              _soundBarOpen = false;
                                            });
                                          }
                                        });
                                        setState(() {
                                          _soundBarOpen = !_soundBarOpen;
                                        });
                                      },
                                      icon: volume == 0
                                          ? Icons.volume_mute_rounded
                                          : (volume > 0.5)
                                              ? Icons.volume_up_rounded
                                              : Icons.volume_down_rounded,
                                      size: iconSize,
                                    ),
                                  ),
                                  // video progress bar
                                  SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor:
                                          Theme.of(context).colorScheme.primary,
                                      trackHeight: size.height * 0.12,
                                      inactiveTrackColor:
                                          Colors.grey.withAlpha(60),
                                      thumbColor: Colors.white,
                                      overlayColor:
                                          Colors.black.withOpacity(0.1),
                                      trackShape:
                                          const RoundedRectSliderTrackShape(),
                                      thumbShape: PointyCircleThumbShape(
                                        sliderBarSize: size.height * 0.12,
                                        thumbRadius: size.width * 0.007,
                                      ),
                                      overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: size.width * 0.02,
                                      ),
                                    ),
                                    child: Expanded(
                                      child: Stack(
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        children: [
                                          Slider(
                                            value: _secondsPlayed /
                                                _movie.duration,
                                            onChanged: _updateVideoTime,
                                          ),
                                          Container(
                                            alignment: Alignment.bottomRight,
                                            padding: EdgeInsets.only(
                                              right: size.width * 0.04,
                                              bottom: size.height * 0.005,
                                            ),
                                            child: Text(
                                              playTime,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(
                                                    fontSize:
                                                        size.width * 0.018,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  PiPSwitcher(
                                    childWhenEnabled: CustomIconButton(
                                      size: iconSize,
                                      onTap: () {},
                                      icon: Icons.expand_outlined,
                                    ),
                                    childWhenDisabled: CustomIconButton(
                                      size: iconSize,
                                      onTap: _enablePip,
                                      icon: Icons.picture_in_picture,
                                    ),
                                    floating: _floating,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (_soundBarOpen) ...[
                          // show a volume slider bar above the volume button
                          // Align(
                          //   alignment: Alignment.bottomLeft,
                          //   child: Padding(
                          //     padding: EdgeInsets.only(
                          //       left: size.width * 0.18,
                          //       bottom: size.height * 0.1,
                          //     ),
                          //     child: RotatedBox(
                          //       quarterTurns: 1,
                          //       child: SizedBox(
                          //         width: size.height * 0.4,
                          //         height: size.width * 0.001,
                          //         child: Slider(
                          //           value: volume,
                          //           onChanged: (double value) {
                          //             debugPrint('changing volume');
                          //             var config =
                          //                 ref.read(configServiceProvider);
                          //             ref
                          //                 .read(
                          //                   configServiceProvider.notifier,
                          //                 )
                          //                 .saveApplicationSettings(
                          //                   config.copyWith(
                          //                     movieVolume: value,
                          //                   ),
                          //                 );

                          //             // update video sound settings
                          //             _videoController?.setVolume(value);
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (_videoController != null &&
                !_videoController!.value.isPlaying) ...[
              // Play button
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _onVideoTap,
                child: Center(
                  child: Icon(
                    Icons.pause_circle_filled,
                    size: size.width * 0.1,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _setVideoUpdateTimer() {
    _updateTimer =
        Timer.periodic(Duration(seconds: _timerUpdateInterval), (timer) {
      if (_videoController == null) {
        _secondsPlayed += 60;
      } else {
        _secondsPlayed += _timerUpdateInterval;
        _videoController!.position.then((value) {
          var playedSeconds = value?.inSeconds ?? 0;
          _secondsPlayed =
              (playedSeconds != 0) ? playedSeconds : _secondsPlayed;
        });
      }
      if (_secondsPlayed >= _movie.duration) {
        ref.read(movieSettingsProvider.notifier).updateMovieUserSettings(
              _settings.copyWith(
                timeWatched: 0,
                // TODO(freek): Maybe add property to indicate seen once?
              ),
            );
        _videoController?.pause();
        Navigator.of(context).pop(true);
      } else {
        ref.read(movieSettingsProvider.notifier).updateMovieUserSettings(
              _settings.copyWith(
                timeWatched: _secondsPlayed,
              ),
            );
        setState(() {});
      }
    });
  }

  void _onVideoTap() {
    if (!_hideControls) {
      if (_videoController != null && _videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    }
    _setAutoHideTimer();
  }

  Future<void> _checkPipEnabled() async {
    var status = await _floating.pipStatus;
    if (_pipMode && status == PiPStatus.disabled) {
      setState(() {
        _pipMode = false;
      });
    }
  }

  Future<ClosedCaptionFile> _getSubtitle(String url) async {
    if (url.isEmpty) {
      return SubRipCaptionFile('');
    }
    var file = NetworkAssetBundle(Uri(path: url));
    var data = await file.load(url);
    return SubRipCaptionFile(
      utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
    );
  }

  void _initializeVideo() {
    if (_movie.video.isNotEmpty) {
      // add closed caption file to the video player
      _videoController = VideoPlayerController.network(
        _movie.video,
        closedCaptionFile: _getSubtitle(_movie.subtitleFile),
        videoPlayerOptions: VideoPlayerOptions(),
      )..initialize().then((_) {
          setState(() {});
          _videoController?.setVolume(
            ref.read(configServiceProvider).movieVolume,
          );
          _videoController?.seekTo(Duration(seconds: _secondsPlayed));
          _videoController?.play();
        });
    } else {
      _videoController = null;
    }
  }

  Future<void> _enablePip() async {
    await _floating.enable(const Rational.landscape());
    _pipMode = true;
    setState(() {});
  }

  void _updateVideoTime(double value) {
    _secondsPlayed = (value * _movie.duration).toInt();
    ref.read(movieSettingsProvider.notifier).updateMovieUserSettings(
          _settings.copyWith(timeWatched: _secondsPlayed),
        );
    _videoController?.seekTo(Duration(seconds: _secondsPlayed));
    setState(() {});
  }

  void _setAutoHideTimer() {
    setState(() {
      _hideControls = false;
    });
    _controlHideTimer = Timer(const Duration(seconds: 10), () {
      if (mounted && ref.read(configServiceProvider).autoHideVideoControls) {
        setState(() {
          _hideControls = true;
        });
      }
    });
  }
}
